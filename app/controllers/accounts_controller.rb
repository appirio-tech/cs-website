class AccountsController < ApplicationController
  before_filter :require_login
  before_filter :get_account, :except => ["require_password","reset_password"]
  
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
      Members.update(current_access_token, @current_user.username,params["form_details"])
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
  end

  # Send a passcode by mail for password reset
  def require_password
    if params[:form_require_password]
      response = Password.reset(params[:form_require_password][:name])
      if response.message == "OK"
        flash[:notice] = "An email has been sent to you"
      else
        flash[:notice] = "An error occured. Your password has not been reset"
      end
    end
  end

  # Check the passwode et new password and update it
  def reset_password
    if params[:form_reset_password]
      passcode    = params[:form_reset_password][:passcode]
      new_password = params[:form_reset_password][:new_password]

      response = Password.update("testuser@cloudspokes.com.dev091",passcode,new_password)

      if response.message == "password changed successfully."
        flash[:notice] = "Your password has been updated. Please connect."
        redirect_to url_for(:controller => 'content', :action => 'show') and return
      else
        flash[:notice] = "Error when trying to update your password. Please check your passcode and password."
        redirect_to '/reset_password' and return
      end
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
