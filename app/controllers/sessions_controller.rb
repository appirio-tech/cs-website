require "auth"
require 'services'

class SessionsController < ApplicationController
  
  # first time users login they will use the popup
  def login_popup
    session[:redirect_to_after_auth] = request.env['HTTP_REFERER']
    @login_form = LoginForm.new
    render :layout => "blank"
  end  
  
  # if any errors during login they will see this page
  def login
    # delete the session from their last login attempt if still there
    session.delete(:auth) unless session[:auth].nil?
    @login_form = LoginForm.new
  end
  
  # signup with cs u/p
  def signup
    @signup_form = SignupForm.new
  end
  
  # submit cs u/p to sfdc
  def signup_cs_create
    
    @signup_form = SignupForm.new(params[:signup_form])
    if @signup_form.valid?
      
      # remove the password_confirmation key from the hash
      params[:signup_form].delete(:password_confirmation)
                  
      # create the member and user in sfdc
      results = Services.new_member(current_access_token, params[:signup_form])
    
      logger.info "[SessionsController]==== creating a new cloudspokes user for #{params[:signup_form][:username]} with results: #{results}"
    
      if results[:success].eql?('true')
    
        # add the sfdc_username to the hash so we can insert locally
        params[:signup_form][:sfdc_username] = results[:sfdc_username]
        # remove the terms_of_service key from the hash
        params[:signup_form].delete(:terms_of_service)
        @user = User.new(params[:signup_form])
      
        # success!!
        if @user.save
          logger.info "[SessionsController]==== successfully created cloudspokes user: #{params[:signup_form][:username]}"
          sign_in @user
          # send the 'welcome' email
          Resque.enqueue(WelcomeEmailSender, current_access_token, results[:sfdc_username]) unless ENV['MAILER_ENABLED'].eql?('false')
          redirect_to challenges_path
        else
          # could not save the user in the database
          logger.error "[SessionsController]==== could not save new user to database: #{@user.errors}"
          flash.now[:error] = @user.errors.full_messages
          render :action => 'signup'
        end
      
      else
        # could not create the user in sfdc.
        logger.info "[SessionsController]==== could not create user in sfdc: #{results[:message]}"
        flash.now[:error] = results[:message]
        render :action => 'signup'
      end

    else     
      # not valid. display signup for with errors from validations
      render :action => 'signup'
    end
    
  end
  
  def callback
        
    # pass on omniauth hash and provider to our auth module
    as = AuthSession.new(request.env['omniauth.auth'], params[:provider])
    
    logger.info "[SessionsController]==== starting callback for #{params[:provider]} for #{as.get_hash[:username]}"
            
    # see if they exist as a member with these third party credentials
    user_exists_results = Services.sfdc_username(current_access_token, as.get_hash[:provider], thirdparty_username(as.get_hash))
    logger.info "[SessionsController]==== does the user #{thirdparty_username(as.get_hash)} for #{as.get_hash[:provider]} exist: #{user_exists_results}"
    
    # bad session!!!
    if user_exists_results[:message].eql?('Session expired or invalid')
      logger.error "[SessionsController]==== error starting a new session?: #{user_exists_results[:message].to_yaml}"
      render :inline => "Whoops! An error occured during the authorization process. Please hit the back button and try again."
    else
    
      # if no user was returned, send them to the signup page
      if user_exists_results[:success].eql?('false')      
        session[:auth] = {:email => as.get_hash[:email], :name => as.get_hash[:name], :username => as.get_hash[:username], :provider => as.get_hash[:provider]}
        redirect_to signup_complete_path 
          
      # user already exists. log them in
      else
        # make sure their user in sfdc is active ---- THIS MAY NOT BE THE CORRECT USERNAME???
        Services.activate_user(current_access_token, as.get_hash[:username])
        
        # log them in
        user = User.authenticate_third_party(current_access_token, as.get_hash[:provider],thirdparty_username(as.get_hash))
        if user.nil?
          logger.error "[SessionsController]==== error logging in user: #{thirdparty_username(as.get_hash)} with #{as.get_hash[:provider]}."
          flash[:error] = "Sorry... we were not able to log you in. Something really bad happened."
        else
          sign_in user
          if session[:redirect_to_after_auth].nil?
            redirect_to challenges_path
          else
            redirect_to session[:redirect_to_after_auth] 
          end
        end
      end
      
    end
    
    rescue OAuth::Unauthorized => e
      logger.error e.response.inspect
  end
  
  # agree to the tos and complete the signup
  def signup_complete

    if params[:signup_complete_form]
      
      @signup_complete_form = SignupCompleteForm.new(params[:signup_complete_form])

      if @signup_complete_form.valid?
        
        # try and create the member in sfdc
        new_member_create_results = Services.new_member(current_access_token, params[:signup_complete_form])
        logger.info "[SessionsController]==== creating a new third party user with email address (#{@signup_complete_form.email}): #{new_member_create_results.to_yaml}"
        
        # if the user was created successfully in sfdc
        if new_member_create_results[:success].eql?('true')
          
          # delete the user if they already exists
          User.delete(User.find_by_username(new_member_create_results[:username]))
          
          user = User.new(:username => new_member_create_results[:username], :sfdc_username => new_member_create_results[:sfdc_username], 
            :password => ENV['THIRD_PARTY_PASSWORD'])
            
          logger.info "[SessionsController]==== try to save #{@signup_complete_form.email} to the database"

          if user.save
            logger.info "[SessionsController]==== saving #{@signup_complete_form.email} to the database"
            # sign the user in
            sign_in user
            logger.info "[SessionsController]==== #{@signup_complete_form.email} successfully signed in"
            # send the 'welcome' email
            Resque.enqueue(WelcomeEmailSender, current_access_token, new_member_create_results[:username]) unless ENV['MAILER_ENABLED'].eql?('false')
            if session[:redirect_to_after_auth].nil?
              redirect_to challenges_path
            else
              redirect_to session[:redirect_to_after_auth] 
            end
          else
            logger.error "[SessionsController]==== error creating a new third party member after manually entering their email address. Could not save to database."
            render :inline => "Whoops! An error occured during the authorization process. Please hit the back button and try again."
          end  
          
        # display the error to them in the flash
        else  
          p new_member_create_results
          flash.now[:error] = new_member_create_results[:message]
        end
      end
    else
      # first time through -- prepopulate the form from the session
      @signup_complete_form = SignupCompleteForm.new(session[:auth])
      if ['github','twitter'].include?(@signup_complete_form.provider) 
        @signup_complete_form.provider_username = @signup_complete_form.username
      else
        @signup_complete_form.provider_username = @signup_complete_form.email        
      end
      
      logger.info "[SessionsController]==== starting the signup process for #{session[:auth][:provider]}"
    end
  end  
  
  def callback_failure
    logger.error "[SessionsController]==== authentication via omniauth failed:"
    logger.error request.env["omniauth"].to_yaml
    redirect_to root_url
  end
    
  # authenticate them against sfdc in with cloudspokes u/p
  def login_cs_auth
    @login_form = LoginForm.new(params[:login_form])
    if @login_form.valid?
      
      # make sure their user in sfdc is active
      Services.activate_user(current_access_token, params[:login_form][:username])

      user = User.authenticate(current_access_token, params[:login_form][:username],
          params[:login_form][:password])

      if user.nil?
        flash.now[:error] = "Invalid username/password combination."
        render :action => 'login'
      else
        sign_in user
        redirect_to challenges_path
      end

    else
      # show the error message
      render :action => 'login'
    end
    
  end
  
  def forgot_service
    if params[:form_forgot_service]
      if !params[:form_forgot_service][:username].empty?
        account = Members.find_by_username(current_access_token, params[:form_forgot_service][:username], 'Login_Managed_By__c')[0]
        if account.nil? || account['errorCode']
          flash.now[:error] = "Could not find a member with the CloudSpokes username '#{params[:form_forgot_service][:username]}'"
        else
          @login_service = "#{account["Login_Managed_By__c"]}"
        end
      else
        flash.now[:error] = 'Please enter a CloudSpokes username.'
      end
    end
  end
  
  # Send a passcode by mail for password reset
  def public_forgot_password
  end
  
  # Send a passcode by mail for password reset
  def public_forgot_password_send
    if params[:form_forgot_password]
      results = Password.reset(params[:form_forgot_password][:username])
      if results['Success'].eql?('true')
        flash[:notice] = results["Message"]
        redirect_to reset_password_url
      else 
        flash[:error] = results["Message"]
        redirect_to forgot_password_url
      end
    end
  end

  # Check the passwode et new password and update it
  def public_reset_password
    @reset_form = ResetPasswordForm.new
  end
  
  # Check the passwode et new password and update it
  def public_reset_password_submit
    @reset_form = ResetPasswordForm.new(params[:reset_password_form])
    if @reset_form.valid?
      results = Password.update(params[:reset_password_form][:username], params[:reset_password_form][:passcode], params[:reset_password_form][:password])
      flash.now[:warning] = results["Message"]
      render :action => 'public_reset_password'
    else
      # not valid. display signup for with errors
      render :action => 'public_reset_password'
    end
  end

  def login_required 
  end

  def destroy 
    sign_out
    redirect_to root_path
  end

end
