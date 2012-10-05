require 'auth'
require 'sfdc_connection'
require 'cs_api_account'

class SessionsController < ApplicationController
  
  before_filter :redirect_to_https, :only => [:login_popup,:login,:signup,:callback]
  before_filter :prevent_appirio_cs_signups, :only => [:signup_cs_create]
  
  def redirect_to_https
    redirect_to url_for params.merge({:protocol => 'https://'}) unless (request.ssl? or Rails.env.development? or Rails.env.test?)
  end
  
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
  
  def signup_referral
    @signup_form = SignupForm.new(referral_hash)
    render 'signup'
  end
  
  # signup with cs u/p
  def signup
    # save the google ad tracking to a marketing hash in the session -- delete a session if exist
    session.delete(:marketing) unless session[:marketing].nil?
    # check for google marketing info to store for the member
    if params[:utm_source]
      marketing = { :campaign_source => params[:utm_source], :campaign_medium => params[:utm_medium], 
        :campaign_name => params[:utm_campaign] }
      session[:marketing] = marketing
    end
    @signup_form = SignupForm.new
  end
  
  # submit cs u/p to sfdc
  def signup_cs_create
    
    if params[:signup_form]
      @signup_form = SignupForm.new(params[:signup_form])
      if @signup_form.valid?
        
        # remove the password_confirmation key from the hash
        params[:signup_form].delete(:password_confirmation)
                    
        # create the member and user in sfdc
        results = CsApi::Account.create(SfdcConnection.admin_dbdc_client.oauth_token, params[:signup_form]).symbolize_keys!
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
            Resque.enqueue(WelcomeEmailSender, current_access_token, params[:signup_form][:username]) unless ENV['MAILER_ENABLED'].eql?('false')
            # add the user to badgeville
            Resque.enqueue(NewBadgeVilleUser, current_access_token, params[:signup_form][:username], results[:sfdc_username]) unless ENV['BADGEVILLE_ENABLED'].eql?('false')
            # update their member info in sfdc with the marketing data
            unless session[:marketing].nil?
              Resque.enqueue(MarketingUpdateNewMember, current_access_token, params[:signup_form][:username], session[:marketing]) 
              # delete the marketing session hash
              session.delete(:marketing)
            end
            # check for any referral & update the record with the newly created member
            unless session[:referral].nil?
              Resque.enqueue(ProcessReferral, session[:referral], params[:signup_form][:username])     
              # delete the referral_id session hash
              session.delete(:referral)
            end
            redirect_to welcome2cloudspokes_path
          else
            # could not save the user in the database
            logger.error "[SessionsController]==== could not save new user to database: #{@user.errors.full_messages}"
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

    else
      redirect_to signup_path
    end

  end
  
  def callback
        
    # pass on omniauth hash and provider to our auth module
    as = AuthSession.new(request.env['omniauth.auth'], params[:provider])
    
    logger.info "[SessionsController]==== starting callback for #{params[:provider]} for #{as.get_hash[:username]}"
           
    # see if they exist as a member with these third party credentials
    user_exists_results = CsApi::Account.find_by_service(as.get_hash[:provider], 
      thirdparty_username(as.get_hash)).symbolize_keys!
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

        if CsApi::Account.activate(user_exists_results[:username])
        
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
        
        else
          redirect_to login_denied_path
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
        new_member_create_results = CsApi::Account.create(SfdcConnection.admin_dbdc_client.oauth_token, params[:signup_complete_form]).symbolize_keys!
        logger.info "[SessionsController]==== creating a new third party user with email address (#{@signup_complete_form.email}): #{new_member_create_results.to_yaml}"
        
        # if the user was created successfully in sfdc
        if new_member_create_results[:success].eql?('true')
          
          # delete the user if they already exists
          User.delete(User.find_by_username(new_member_create_results[:username]))
          
          user = User.new(:username => new_member_create_results[:username], 
            :sfdc_username => new_member_create_results[:sfdc_username], 
            :password => ENV['THIRD_PARTY_PASSWORD'])
            
          logger.info "[SessionsController]==== try to save #{@signup_complete_form.email} to the database"

          if user.save
            logger.info "[SessionsController]==== saving #{@signup_complete_form.email} to the database"
            # sign the user in
            sign_in user
            logger.info "[SessionsController]==== #{@signup_complete_form.email} successfully signed in"
            # send the 'welcome' email
            Resque.enqueue(WelcomeEmailSender, current_access_token, new_member_create_results[:username]) unless ENV['MAILER_ENABLED'].eql?('false')
            # add the user to badgeville
            Resque.enqueue(NewBadgeVilleUser, current_access_token, new_member_create_results[:username], new_member_create_results[:sfdc_username]) unless ENV['BADGEVILLE_ENABLED'].eql?('false')
            unless session[:marketing].nil?
              # update their info in sfdc with the marketing data
              Resque.enqueue(MarketingUpdateNewMember, current_access_token, new_member_create_results[:username], session[:marketing]) 
              # delete the marketing session hash
              session.delete(:marketing)
            end
            # check for any referral & update the record with the newly created member
            unless session[:referral].nil?
              Resque.enqueue(ProcessReferral, session[:referral], new_member_create_results[:username])     
              # delete the referral_id session hash
              session.delete(:referral)
            end
            redirect_to welcome2cloudspokes_path
          else
            logger.error "[SessionsController]==== error creating a new third party member after manually entering their email address. Could not save to database."
            render :inline => "Whoops! An error occured during the authorization process. Please hit the back button and try again."
          end  
          
        # display the error to them in the flash
        else  
          logger.info "[SessionsController]==== error creating new member: #{new_member_create_results[:message]}"
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
    
    if params[:login_form]
      @login_form = LoginForm.new(params[:login_form])
      if @login_form.valid?
        
        # make sure their user in sfdc is active
        if CsApi::Account.activate(params[:login_form][:username])

          user = User.authenticate(current_access_token, params[:login_form][:username],
              params[:login_form][:password])

          if user.nil?
            flash.now[:error] = "Invalid username/password combination."
            render :action => 'login'
          else
            sign_in user
            if session[:redirect_to_after_auth].nil?
              redirect_to challenges_path
            else
              redirect_to session[:redirect_to_after_auth] 
            end
          end
        
        else
          redirect_to login_denied_path
        end

      else
        # show the error message
        render :action => 'login'
      end
    else
      redirect_to login_path
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
      results = CsApi::Account.reset_password(params[:form_forgot_password][:username])
      if results['success'].eql?('true')
        flash[:notice] = results["message"]
        redirect_to reset_password_url
      else 
        flash[:error] = results["message"]
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
    if params[:reset_password_form]
      @reset_form = ResetPasswordForm.new(params[:reset_password_form])
      if @reset_form.valid?

        CsApi::Account.activate(params[:reset_password_form][:username])
        logger.info "[SessionsController]==== Activating account with cs-api for #{params[:reset_password_form][:username]}"

        results = CsApi::Account.update_password(params[:reset_password_form][:username], params[:reset_password_form][:passcode], params[:reset_password_form][:password])
        flash.now[:warning] = results["message"]
        render :action => 'public_reset_password'
      else
        # not valid. display signup for with errors
        render :action => 'public_reset_password'
      end
    else
      redirect_to reset_password_url
    end
  end

  # redirect anyone trying to login with an appirio address
  def prevent_appirio_cs_signups
    if params[:signup_form]
      redirect_to "http://content.cloudspokes.com/appirio-cloudspokes-users" if params[:signup_form][:email].include?('@appirio.com')
    end
  end  

  def login_required 
  end

  def destroy 
    sign_out
    redirect_to root_path
  end
  
  private
  
    def referral_hash
  
      session.delete(:referral) unless session[:referral].nil?
      # try and find an existing referral
      begin
        # materialize the referral object
        SfdcConnection.admin_dbdc_client.materialize("Referral__c")
        # find by id and throw an error if it doesn't exist
        referral = Referral__c.find(params[:id])
        # set a session var for the referral id so we can pick it up later in the signup process (using oauth?)
        session[:referral] = params[:id]
        { :username => referral.Username__c, :email => referral.Email__c  }
      rescue Databasedotcom::SalesForceError => exc
        # if we threw an error then try to find a member as this may be a referral
        SfdcConnection.admin_dbdc_client.materialize("Member__c")
        # find by username
        member = Member__c.find_by_name(params[:id])
        # if we found a member, set that as the referral
        session[:referral] = params[:id] unless member.nil? 
        # for member referrals, always returns an empty hash
        {}
      end
      
    end

end
