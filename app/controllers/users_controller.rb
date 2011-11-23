class UsersController < ApplicationController
  require 'services'
  
  # signing up with a cloudspokes u/p
  def new
    @user = User.new
  end
          
  # create the cloudspokes member in sfdc from 'new' form
  def create
          
    if params[:user][:password].eql?(params[:user][:password_confirmation])
          
      # remove the password_confirmation key from the hash
      params[:user].delete(:password_confirmation)
          
      # create the member and user in sfdc
      results = Services.new_member(current_access_token, params[:user])
    
      logger.info "[UsersController]==== creating a new cloudspokes user for #{params[:user][:username]} with results: #{results}"
    
      if results[:success].eql?('true')
    
        # add the sfdc_username to the hash so we can insert locally
        params[:user][:sfdc_username] = results[:sfdc_username]
        @user = User.new(params[:user])
      
        if @user.save
          sign_in @user
          # send the 'welcome' email
          Resque.enqueue(WelcomeEmailSender, current_access_token, results[:sfdc_username]) unless ENV['MAILER_ENABLED'].eql?('false')
          redirect_to challenges
        else
          # could not save the user in the database
          flash[:error] = @user.errors.full_messages
          @user = User.new
          render 'new'
        end
      
      else
        # could not create the user in sfdc.
        logger.info "[UsersController]==== counld not create user in sfdc: #{results[:message]}"
        flash[:error] = results[:message]
        @user = User.new
        render 'new'
      end
      
    else
      @user = User.new
      flash[:error] = 'Your passwords do not match'
      redirect_to signup_url
    end
    
  end
  
end