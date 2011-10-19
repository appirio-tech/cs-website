require "auth"
require 'services'

class SessionsController < ApplicationController
  
  def login
    # delete the session from their last login attempt
    session.delete(:authsession)
  end
  
  # if the provider doesn't include an email, redirects them to this form
  def signup_third_party_no_email
  end
  
  # once user enters email for provider, submits and create user & logs in
  def signup_third_party_create
    
    # add the email to the session hash
    session[:authsession].get_hash[:email] = params[:session][:email]
    # try and create the user in sfdc
    new_member_create_results = Services.new_member(session[:authsession].get_hash)
    # if the user was created successfully in sfdc
    if new_member_create_results[:success].eql?('true')

      # now authenticate the user with salesforce to get their auth token and save to db
      user = User.authenticate_third_party(session[:authsession].get_hash[:provider],
          session[:authsession].get_hash[:username])
          
      # delete the session var that stored the auth variables
      session.delete(:authsession)

      if user.nil?
        render :inline => "Whoops! Error. Hit the back button and try again."
      else
        sign_in user
        redirect_to root_path
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
      
      # if the provider does not send us an email, redirect them
      if ['twitter','github'].include?(params[:provider])
        session[:authsession] = as
        redirect_to signup_complete_url
      else
        # try and create the user
        new_member_create_results = Services.new_member(as.get_hash)
        if new_member_create_results[:success].eql?('true')

          user = User.new(:username => new_member_create_results[:username], 
            :sfdc_username => new_member_create_results[:sfdc_username], 
            :password => ENV['third_party_password'])
          user.save
          sign_in user
          redirect_to root_path

        else
          flash[:error] = new_member_create_results[:message]
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
      render :inline => "Authentication failed"
  end
  
  # logging in with cloudspokes u/p
  def create
    
    user = User.authenticate(params[:session][:username],
        params[:session][:password])
    
    if user.nil?
      flash[:error] = "Invalid email/password combination."
      redirect_to '/signin'
    else
      sign_in user
      redirect_to root_path
    end
  end

  def destroy 
    sign_out
    redirect_to root_path
  end
  
  def callback_test
      render :inline => "<html><body><b>Our hash:</b><br>"+as.get_hash.to_s + "<br><br><b>Omniauth hash:</b><br>" + request.env['omniauth.auth'].to_s+"</body></html>"
  end

end
