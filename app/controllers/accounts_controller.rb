class AccountsController < ApplicationController
  before_filter :require_login, :except => ["public_forgot_password","public_reset_password"]
  before_filter :get_account, :except => ["public_forgot_password","public_reset_password"]
  
  def index
    redirect_to '/account/challenges'
  end
  
  def outstanding_reviews
    @challenges = Scoring.outstanding_scorecards(current_access_token)
  end
  
  def scorecard
    scorecard = Scoring.scorecard(current_access_token, params[:id], current_user.username).to_json
    # get the 'message' potion of the string
    message = scorecard[0,scorecard.index('[')].gsub('\\','')
    # see if the scorecard has been scored
    @scored = message.index('"scored__c": "true"').nil? ? false : true
    # set the json results to be html safe are usable in the javascript
    @json = scorecard[scorecard.index('['),scorecard.length].gsub(']}',']').html_safe
  end
  
  def scorecard_save
    save_results = Scoring.save_scorecard(current_access_token, params[:xml],params[:set_as_scored])
    if save_results[:success].eql?('true')
      redirect_to outstanding_reviews_path
    else
      flash[:error] = save_results[:message]
      redirect_to(:back)
    end
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
  def payments
    if params["form_payment"]
      results = Members.update(current_access_token, @current_user.username, params["form_payment"])
      #check for errors!!
      if results["Success"].eql?('false')
        flash.now[:error] = results["Message"]
      else
        flash.now[:notice] = "Your payment information has been updated."
      end
    end
    @payments = Payments.all(current_access_token, :select => 'id,name,challenge__r.name,challenge__r.id__c,money__c,place__c,reason__c,status__c,type__c,Reference_Number__c,payment_sent__c', :where => current_user.username)
    @payments.each do |record| 
      if record['Status__c'].eql?('Paid')
        @show_paid_section = true
      else 
        @show_outstanding_section = true
      end
    end
    get_account
  end

  # Member details info tab
  def details
    if params["form_details"]
      results = Members.update(current_access_token, @current_user.username,params["form_details"])
      #check for errors!!
      if results["Success"].eql?('false')
        if results["Message"].index('Email__c duplicates').nil?
          flash.now[:error] = results["Message"]
        else
          flash.now[:error] = 'Duplicate email address found! The email address that you specified is already in use.'
        end
      else
        flash.now[:notice] = "Your account information has been updated."
      end
    end
    # get the updated account
    get_account
  end

  # School & Work info tab
  def school
    if params["form_school"]
      Members.update(current_access_token, @current_user.username, params["form_school"])
      flash.now[:notice] = "Your school and work information has been updated."      
    end
    # get the updated account
    get_account
  end
  
  # School & Work info tab
  def public_profile
    if params["form_profile"]
      if !params["form_profile"]["Profile_Pic__c"].nil?
        img = params["form_profile"]["Profile_Pic__c"]
        img.rewind
        img.read
        Members.upload_profile_pic(params['postUrl'], img) 
      end
      Members.update(current_access_token, @current_user.username, params["form_profile"])
      flash.now[:notice] = "Your profile information has been updated."
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
        flash.now[:notice] = results["Message"]
      end
    end
    get_account
    if !@account["Login_Managed_By__c"].eql?('CloudSpokes')
      flash.now[:warning] = "You are logging into CloudSpokes with your #{@account["Login_Managed_By__c"]} account. You will need to change your password at #{@account["Login_Managed_By__c"]}"
    end
  end
  
  def password_reset
    @reset_form = ResetPasswordAccountForm.new
    if params[:reset_password_account_form]
      @reset_form = ResetPasswordAccountForm.new(params[:reset_password_account_form])
      if @reset_form.valid?
        results = Password.update(current_user.username, params[:reset_password_account_form][:passcode], 
          params[:reset_password_account_form][:password])
        if results["Success"].eql?('false')
          flash.now[:error] = results["Message"]
        else
          current_user.password = params[:reset_password_account_form][:password]
          current_user.save
          flash.now[:notice] = results["Message"]
        end
      else
        # display the validation messages
      end
    end
  end
  
  def get_account
    @account = Members.find_by_username(current_access_token, @current_user.username, DEFAULT_MEMBER_FIELDS)[0]
  end
  
  private
 
    def require_login
      unless logged_in?
        redirect_to login_required_url, :notice => 'You must be logged in to access this section.'
      end
    end
 
    def logged_in?
      !!current_user
    end
  
end
