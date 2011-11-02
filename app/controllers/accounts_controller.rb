class AccountsController < ApplicationController
  before_filter :require_login, :except => ["public_forgot_password","public_reset_password"]
  before_filter :get_account, :except => ["public_forgot_password","public_reset_password"]
  
  def index
    redirect_to '/account/challenges'
  end

  def challenges
    # Gather challenges for sorting
    @challenges          = Members.challenges(current_access_token, :name => @current_user.username)

    @followed_challenges = []
    @active_challenges   = []
    @past_challenges     = []

    # Sort challenges depending of the end date or status
    @challenges.each do |challenge|
      if challenge["End_Date__c"].to_date > Time.now.to_date
        if challenge['Challenge_Participants__r']['records'].first['Status__c'] == "Watching"
          @followed_challenges << challenge
        else
          @active_challenges << challenge
        end
      else
        @past_challenges << challenge
      end
    end
  end

  # Member details info tab
  def details
    if params["form_details"]
      results = Members.update(current_access_token, @current_user.username,params["form_details"])
      #check for errors!!
      if results["Success"].eql?('false')
        if results["Message"].index('Email__c duplicates').nil?
          flash[:error] = results["Message"]
        else
          flash[:error] = 'Duplicate email address found! The email address that you specified is already in use.'
        end
      end
    end
    # get the updated account
    get_account
  end

  # School & Work info tab
  def school
    if params["form_school"]
      Members.update(current_access_token, @current_user.username,params["form_school"])
    end
    # get the updated account
    get_account
  end

  # Action to change the password of logged user (not activated)
  def password
    if params[:reset]
      results = Password.reset(current_user.username)
      if results['Success'].eql?('true')
        redirect_to password_reset_url, :notice => results["Message"]
      else 
        flash[:notice] = results["Message"]
      end
    end
    get_account
  end
  
  def password_reset
    if params[:form_reset_password]
      #check to make sure their passwords match
      if params[:form_reset_password][:new_password].eql?(params[:form_reset_password][:new_password_again])
        results = Password.update(current_user.username, params[:form_reset_password][:passcode], params[:form_reset_password][:new_password])
        flash[:notice] = results["Message"]
      else
        flash[:notice] = 'Please ensure that your passwords match.'
      end
    end
  end

  # Send a passcode by mail for password reset
  def public_forgot_password
    if params[:form_forgot_password]
      results = Password.reset(params[:form_forgot_password][:username])
      if results['Success'].eql?('true')
        redirect_to reset_password_url, :notice => results["Message"]
      else 
        flash[:notice] = results["Message"]
      end
    end
  end

  # Check the passwode et new password and update it
  def public_reset_password
    #if they submitted the form
    if params[:reset_password_form]
      @reset_form = ResetPasswordForm.new(params[:reset_password_form])
      if @reset_form.valid?

        #check to make sure their passwords match
        if params[:reset_password_form][:new_password].eql?(params[:reset_password_form][:new_password_again])
          results = Password.update(params[:reset_password_form][:username], params[:reset_password_form][:passcode], params[:reset_password_form][:new_password])
          flash[:notice] = results["Message"]
        else
          flash[:notice] = 'Please ensure that your passwords match.'
        end        

      end
    else
      @reset_form = ResetPasswordForm.new
    end
  end
  
  def get_account
    @account = Members.find_by_username(current_access_token, @current_user.username, DEFAULT_MEMBER_FIELDS)[0]
  end
  
  private
 
    def require_login
      unless logged_in?
        redirect_to login_url, :notice => 'You must be logged in to access this section'
      end
    end
 
    def logged_in?
      !!current_user
    end
  
end
