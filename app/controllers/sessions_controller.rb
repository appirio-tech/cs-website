require "auth"
require 'services'

class SessionsController < ApplicationController
  
  def login
    # delete the session from their last login attempt
    session.delete(:authsession) unless session[:authsession].nil?
    @login_form = LoginForm.new
    render :layout => "blank"
  end
  
  def signup
    @user = User.new
    render :layout => "blank"
  end
    
  # if the provider doesn't include an email, redirects them to this form
  def signup_third_party_no_email
  end
  
  # once user enters email for provider, submits and CREATES a user & logs in
  def signup_third_party_create
    
    # add the email to the session hash
    session[:authsession].get_hash[:email] = params[:session][:email]
    # try and create the user in sfdc
    new_member_create_results = Services.new_member(session[:authsession].get_hash)
    
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
        redirect_to '/challenges'
      else
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
            
    # see if they exist as a member with these third party credentials
    user_exists_results = Services.sfdc_username(as.get_hash[:provider], as.get_hash[:username])
    p 'user exists?'
    p user_exists_results
    
    # if no user was returned, then create them
    if user_exists_results[:success].eql?('false')
      
      if user_exists_results[:message].eql?('Session expired or invalid')
        render :inline => "Whoops! An error occured during the authorization process. Please hit the back button and try again."
      end
      
      # if the provider does not send us an email, redirect them
      if ['twitter','github'].include?(params[:provider])
        session[:authsession] = as
        redirect_to signup_complete_url
      else
        # try and create the user in sfdc
        new_member_create_results = Services.new_member(as.get_hash)
        
        if new_member_create_results[:success].eql?('true')

          user = User.new(:username => new_member_create_results[:username], 
            :sfdc_username => new_member_create_results[:sfdc_username], 
            :password => ENV['third_party_password'])
          
          if user.save
            sign_in user
            # send the 'welcome' email
            Resque.enqueue(WelcomeEmailSender, current_access_token, results[:sfdc_username]) unless ENV['MAILER_ENABLED'].eql?('false')
            redirect_to root_path
          else
            render :inline => user.errors.full_messages
          end
        
        # they can't login - taken username or email address?
        else
          redirect_to login_url, :notice => new_member_create_results[:message]
        end
      end
      
    else
      
      # log them in
      user = User.authenticate_third_party(as.get_hash[:provider],as.get_hash[:username])
      if user.nil?
        flash[:error] = "Serious error loggin in!!"
      else
        sign_in user
        redirect_to root_path
      end
      
    end

  end
  def callback_failure
      render :text =>  request.env["omniauth"].to_yaml
  end
    
  # authenticate them against sfdc in with cloudspokes u/p
  def login_cs_auth
    
    @login_form = LoginForm.new(params[:login_form])
    if @login_form.valid?

      user = User.authenticate(params[:login_form][:username],
          params[:login_form][:password])

      if user.nil?
        flash[:error] = "Invalid email/password."
        redirect_to login_url
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
      #check to make sure their passwords match
      if params[:reset_password_form][:new_password].eql?(params[:reset_password_form][:new_password_again])
        results = Password.update(params[:reset_password_form][:username], params[:reset_password_form][:passcode], params[:reset_password_form][:new_password])
        flash[:warning] = results["Message"]
      else
        flash[:error] = 'Please ensure that your new passwords match.'
      end  
      redirect_to reset_password_url
    else
      flash[:error] = "Please ensure that you fill out all form fields."
      redirect_to reset_password_url
    end
  end

  def destroy 
    sign_out
    redirect_to root_path
  end

end
