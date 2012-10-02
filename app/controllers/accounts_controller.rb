class AccountsController < ApplicationController
  before_filter :require_login, :except => ["public_forgot_password","public_reset_password"]
  before_filter :get_account, :except => ["public_forgot_password","public_reset_password"]
  before_filter :redirect_to_http
   
  def index
    redirect_to '/account/challenges'
  end
    
  def outstanding_reviews
    @page_title = "Outstanding Reviews"
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
    @current_submissions = Challenges.current_submissions(current_access_token, params[:id])
  end
  
  def scorecard_save
    save_results = Scoring.save_scorecard(current_access_token,params[:participantId],params[:json],params[:set_as_scored],params[:delete_participant_submission])
    if save_results[:success].eql?('true')
      redirect_to outstanding_reviews_path
    else
      flash[:error] = save_results[:message]
      redirect_to(:back)
    end
  end

  def challenges
    @page_title = "Your Challenges"
    # Gather challenges for sorting
    @challenges          = Members.challenges(current_access_token, :name => @current_user.username)

    @followed_challenges = []
    @active_challenges   = []
    @past_challenges     = []

    # Sort challenges depending of the end date or status
    @challenges.each do |challenge|
      if challenge['Challenge_Participants__r']['records'][0]['Status__c'].eql?('Watching') &&
        ['Created','Review','Review - Pending'].include?(challenge['Status__c'])
          @followed_challenges << challenge
      elsif !challenge['Challenge_Participants__r']['records'][0]['Status__c'].eql?('Watching') &&
        ['Created','Review','Review - Pending'].include?(challenge['Status__c'])
          @active_challenges << challenge
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
    # get the member's id for docusign
    member = Members.find_by_username(current_access_token, @current_user.username, 'id').first
    @memberId = member['Id']
    @payments = Members.payments(current_access_token, @current_user.username)
    @payments.each do |record| 
      if record['status'].eql?('Paid')
        @show_paid_section = true
      else 
        @show_outstanding_section = true
      end
    end
    @page_title = "Your Payments and Payment Info"
    get_account
    respond_to do |format|
      format.html
      format.json { render :json => @payments }
    end
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
    @page_title = "Account Details"
    # get the updated account
    get_account
  end

  # School & Work info tab
  def school
    if params["form_school"]
      Members.update(current_access_token, @current_user.username, params["form_school"])
      flash.now[:notice] = "Your school and work information has been updated."      
    end
    @page_title = "Account Details"
    # get the updated account
    get_account
  end
  
  # School & Work info tab
  def public_profile
    if params["form_profile"]
      Members.update(current_access_token, @current_user.username, params["form_profile"])
      Resque.enqueue(UpdateBadgeVillePlayer, current_access_token, @current_user.username, DEFAULT_MEMBER_FIELDS) unless ENV['BADGEVILLE_ENABLED'].eql?('false')
      flash.now[:notice] = "Your profile information has been updated."
    end
    @page_title = "Public Profile"
    # get the updated account
    get_account
  end

  # Action to change the password of logged user (not activated)
  def password    
    if params[:reset]
      results = Account.reset_password(current_user.username)
      if results['success'].eql?('true')
        redirect_to password_reset_url, :notice => results["message"]
      else 
        flash.now[:notice] = results["message"]
      end
    end
    @page_title = "Change Your Password"
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
        results = Account.update_password(current_user.username, params[:reset_password_account_form][:passcode], 
          params[:reset_password_account_form][:password])
        if results["success"].eql?('false')
          flash.now[:error] = results["message"]
        else
          current_user.password = params[:reset_password_account_form][:password]
          current_user.save
          flash.now[:notice] = results["message"]
        end
      else
        # display the validation messages
      end
    end
  end

  def communities
    @communities = SfdcConnection.dbdc_client(current_access_token).query("select name, about__c, members__c from community__c order by name")
  end
  
  def get_account
    @account = Members.find_by_username(current_access_token, @current_user.username, DEFAULT_MEMBER_FIELDS)[0]
  end
  
end
