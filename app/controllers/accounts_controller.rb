class AccountsController < ApplicationController
  before_filter :get_account, :except => ["require_password","reset_password"]

  def challenges
    # Gather challenges for sorting
    @challenges          = Members.challenges(:name => @account["Name"])

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
      Members.update(@account["Name"],params["form_details"])
    end
    @account = Members.find(params[:id])
  end

  # School & Work info tab
  def school
    if params["form_school"]
      Members.update(@account["Name"],params["form_school"])
    end
    @account = Members.find(params[:id])
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
    @account = Members.find(params[:id])
  end
end
