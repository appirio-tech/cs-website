require "auth"
require 'services'

class SessionsController < ApplicationController
  
  def login
    session[:redirect_to_after_auth] = request.env['HTTP_REFERER']
    # delete the session from their last login attempt
    session.delete(:authsession) unless session[:authsession].nil?
    @login_form = LoginForm.new
    render :layout => "blank"
  end
  
  def signup
    @signup_form = SignupForm.new
    render :layout => "blank"
  end
    
  # if the provider doesn't include an email, redirects them to this form
  def signup_third_party_no_email
    logger.info "[SessionsController]==== requesting manual email address for #{session[:authsession].get_hash[:provider]} signup"
  end
  
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
        @user = User.new(params[:signup_form])
      
        if @user.save
          logger.info "[SessionsController]==== successfully created cloudspokes user: #{@user}"
          sign_in @user
          # send the 'welcome' email
          Resque.enqueue(WelcomeEmailSender, current_access_token, results[:sfdc_username]) unless ENV['MAILER_ENABLED'].eql?('false')
          # render the signup_cs_create to close the window and reload the page
        else
          # could not save the user in the database
          logger.error "[SessionsController]==== could not save new user to database: #{@user.errors}"
          flash.now[:error] = @user.errors.full_messages
          render :action => 'signup', :layout => 'blank'
        end
      
      else
        # could not create the user in sfdc.
        logger.info "[SessionsController]==== could not create user in sfdc: #{results[:message]}"
        flash.now[:error] = results[:message]
        render :action => 'signup', :layout => 'blank'
      end

    else     
      # not valid. display signup for with errors
      render :action => 'signup', :layout => 'blank'
    end
    
  end
  
  # once user enters email for provider, submits and CREATES a user & logs in
  def signup_third_party_create
    
    # add the email to the session hash
    session[:authsession].get_hash[:email] = params[:session][:email]
    # try and create the user in sfdc
    new_member_create_results = Services.new_member(current_access_token, session[:authsession].get_hash)
    logger.info "[SessionsController]==== creating a new third party with a manual email address (#{params[:session][:email]}): #{new_member_create_results.to_yaml}"
    
    # if the user was created successfully in sfdc
    if new_member_create_results[:success].eql?('true')
      
      user = User.new(:username => new_member_create_results[:username], :sfdc_username => new_member_create_results[:sfdc_username], 
        :password => ENV['third_party_password'])
      
      if user.save
        # delete the session var that stored the auth variables
        session.delete(:authsession)
        # sign the user in
        sign_in user
        # send the 'welcome' email
        Resque.enqueue(WelcomeEmailSender, current_access_token, new_member_create_results[:username]) unless ENV['MAILER_ENABLED'].eql?('false')
        redirect_to session[:redirect_to_after_auth]
      else
        logger.error "[SessionsController]==== error creating a new third party member after manually entering their email address. could not save to database."
        render :inline => "Whoops! An error occured during the authorization process. Please hit the back button and try again."
      end

    else
      flash[:error] = new_member_create_results[:message]
      redirect_to signup_complete_url
    end
  end
  
  def callback
        
    # pass on omniauth hash and provider to our auth module
    as = AuthSession.new(request.env['omniauth.auth'], params[:provider])
    
    logger.info "[SessionsController]==== starting callback for #{params[:provider]} for #{as.get_hash[:username]}"
            
    # see if they exist as a member with these third party credentials
    user_exists_results = Services.sfdc_username(current_access_token, as.get_hash[:provider], as.get_hash[:username])
    logger.info "[SessionsController]==== does the user exist: #{user_exists_results}"
    
    # bad session!!!
    if user_exists_results[:message].eql?('Session expired or invalid')
      logger.error "[SessionsController]==== error starting a new session?: #{user_exists_results[:message].to_yaml}"
      render :inline => "Whoops! An error occured during the authorization process. Please hit the back button and try again."
    else
    
      # if no user was returned, then create them
      if user_exists_results[:success].eql?('false')
      
        # if the provider does not send us an email, redirect them
        if ['twitter','github'].include?(params[:provider])
          session[:authsession] = as
          redirect_to signup_complete_url
        else
          # try and create the user in sfdc
          new_member_create_results = Services.new_member(current_access_token, as.get_hash)
        
          if new_member_create_results[:success].eql?('true')

            user = User.new(:username => new_member_create_results[:username], 
              :sfdc_username => new_member_create_results[:sfdc_username], 
              :password => ENV['third_party_password'])
          
            if user.save
              sign_in user
              # send the 'welcome' email
              Resque.enqueue(WelcomeEmailSender, current_access_token, results[:sfdc_username]) unless ENV['MAILER_ENABLED'].eql?('false')
              redirect_to session[:redirect_to_after_auth]
            else
              render :inline => user.errors.full_messages
            end
        
          # they can't login - taken username or email address?
          else
            redirect_to login_url, :notice => new_member_create_results[:message]
          end
        end
      
      # user already exists. log them in
      else
        # make sure their user in sfdc is active
        Services.activate_user(current_access_token, as.get_hash[:username])
        
        # log them in
        user = User.authenticate_third_party(current_access_token, as.get_hash[:provider],as.get_hash[:username])
        if user.nil?
          logger.error "[SessionsController]==== error logging in user: #{as.get_hash[:username]} with #{as.get_hash[:provider]}."
          flash[:error] = "Serious error loggin in!!"
        else
          sign_in user
          redirect_to session[:redirect_to_after_auth]
        end
      end
      
    end

  end
  def callback_failure
    logger.error "authentication via omniauth failed:"
    logger.error request.env["omniauth"].to_yaml
    redirect_to root_url
  end
    
  # authenticate them against sfdc in with cloudspokes u/p
  def login_cs_auth
    
    
    @login_form = LoginForm.new(params[:login_form])
    if @login_form.valid?
      
      # make sure their user in sfdc is active
      Services.activate_user(current_access_token, params[:login_form][:username])

      user = User.authenticate(params[:login_form][:username],
          params[:login_form][:password])

      if user.nil?
        flash.now[:error] = "Invalid email/password."
        render :action => 'login', :layout => 'blank'
      else
        sign_in user
        render :layout => "blank"
      end

    else
      redirect_to login_url
    end
    
  end
  
  # Send a passcode by mail for password reset
  def public_forgot_password
    render :layout => "blank"
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
    render :layout => "blank"
  end
  
  # Check the passwode et new password and update it
  def public_reset_password_submit
    @reset_form = ResetPasswordForm.new(params[:reset_password_form])
    if @reset_form.valid?
      results = Password.update(params[:reset_password_form][:username], params[:reset_password_form][:passcode], params[:reset_password_form][:password])
      flash.now[:warning] = results["Message"]
      render :action => 'public_reset_password', :layout => 'blank'
    else
      # not valid. display signup for with errors
      render :action => 'public_reset_password', :layout => 'blank'
    end
  end

  def login_required 
  end

  def destroy 
    sign_out
    redirect_to root_path
  end

end
