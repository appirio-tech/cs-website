require 'cs_api_account'
require 'cs_api_member'
require 'cs_api_judging'
require 'cs_api_community'
require 'atomentry_judging'

class AccountsController < ApplicationController

  before_filter :require_login, :except => [:public_forgot_password, :public_reset_password]
  before_filter :get_account, :only => [:details, :payments, :school, :public_profile, :password]
  before_filter :redirect_to_http
   
  def index
    redirect_to '/account/challenges'
  end

  def judging_queue
    @challenges = CsApi::Judging.queue(current_access_token)
    @total_wins = CsApi::Member.find_by_membername(current_access_token, 
      current_user.username, PRETTY_PUBLIC_MEMBER_FIELDS)['total_wins']
  end 

  # can't get this to create a feed is subscribable!! argh!!
  def judging_feed    
    challenges = CsApi::Judging.queue(current_access_token)

    @feed_items = Array.new   
    @feed_title = 'CloudSpokes Judging Queue'

    unless challenges.nil?      
      challenges.each do |challenge|
        entry = AtomEntryJudging.new(:id => challenge['id'], :title => challenge['name'], :end_date => challenge['end_date'],  
          :due_date => challenge['winner_announced'], :categories => challenge['challenge_categories__r'])
        @feed_items.push(entry)
      end
    end

    respond_to do |format|
      format.atom { render :layout => false }
      # we want the RSS feed to redirect permanently to the ATOM feed
      format.rss { redirect_to judging_feed_path(:format => :atom), :status => :moved_permanently }
    end

  end     

  def add_judge
    render :text => CsApi::Judging.add(current_access_token, {'challenge_id' => params[:id], 
      'membername' => current_user.username})['message']
  end    

  def invite
    if params['invite']
      params[:invite].each do |email|
        Resque.enqueue(InviteEmailSender, current_user.username, email.second)
      end     
      flash.now[:notice] = 'Your invites have been sent!'
    end
    @page_title = "Invite your friends to join CloudSpokes"
  end   

  def referrals
    @page_title = "Referred CloudSpokes Members"
    @referrals = CsApi::Member.referrals(current_access_token, current_user.username)
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
    @challenges = CsApi::Member.challenges(current_access_token, @current_user.username)

    @followed_challenges = []
    @active_challenges   = []
    @past_challenges     = []

    # Sort challenges depending of the end date or status
    @challenges.each do |challenge|
      if challenge['challenge_participants__r']['records'][0]['status'].eql?('Watching') &&
        ACTIVE_CHALLENGE_STATUSES.include?(challenge['status'])
          @followed_challenges << challenge
      elsif !challenge['challenge_participants__r']['records'][0]['status'].eql?('Watching') &&
        ACTIVE_CHALLENGE_STATUSES.include?(challenge['status'])
          @active_challenges << challenge
      else
        @past_challenges << challenge
      end
    end
  end
  
  # Member details info tab
  def payments
    if params['form_payment']
      results = CsApi::Member.update(current_access_token, @current_user.username, params['form_payment'])
      #check for errors!!
      if results['success'].eql?('false')
        flash.now[:error] = results['message']
      else
        flash.now[:notice] = 'Your payment information has been updated.'
        get_account
      end
    end
    # set the member's id for docusign
    @memberId = @account['id']
    @payments = CsApi::Member.payments(current_access_token, @current_user.username)
    @payments.each do |record| 
      if record['status'].eql?('Paid')
        @show_paid_section = true
      else 
        @show_outstanding_section = true
      end
    end
    @page_title = 'Your Payments and Payment Info'
    respond_to do |format|
      format.html
      format.json { render :json => @payments }
    end
  end

  # Member details info tab
  def details
    if params['form_details']
      results = CsApi::Member.update(current_access_token, @current_user.username, params['form_details'])
      #check for errors!!
      if results['success'].eql?('false')
        if results['message'].index('Email__c duplicates').nil?
          flash.now[:error] = results['message']
        else
          flash.now[:error] = 'Duplicate email address found! The email address that you specified is already in use.'
        end
      else
        flash.now[:notice] = 'Your account information has been updated.'
        # get the updated account
        get_account         
      end     
    end
    @page_title = 'Account Details'
  end

  # School & Work info tab
  def school
    if params['form_school']
      CsApi::Member.update(current_access_token, @current_user.username, params['form_school'])
      flash.now[:notice] = "Your school and work information has been updated."    
      # get the updated account
      get_account   
    end
    @page_title = 'Account Details'
  end
  
  # School & Work info tab
  def public_profile
    if params['form_profile']
      CsApi::Member.update(current_access_token, @current_user.username, params['form_profile'])
      Resque.enqueue(UpdateBadgeVillePlayer, current_access_token, @current_user.username, 'name,first_name,last_name,profile_pic,badgeville_id') unless ENV['BADGEVILLE_ENABLED'].eql?('false')
      flash.now[:notice] = 'Your profile information has been updated.'
      # get the updated account
      get_account      
    end
    @page_title = 'Public Profile'
  end

  # Action to change the password of logged user (not activated)
  def password    
    if params[:reset]
      results = CsApi::Account.reset_password(current_user.username)
      if results['success'].eql?('true')
        redirect_to password_reset_url, :notice => results["message"]
      else 
        flash.now[:notice] = results["message"]
      end
      get_account
    end
    @page_title = "Change Your Password"
    if !@account["login_managed_by"].eql?('CloudSpokes')
      flash.now[:warning] = "You are logging into CloudSpokes with your #{@account["login_managed_by"]} account. You will need to change your password at #{@account["login_managed_by"]}"
    end
  end
  
  def password_reset
    @reset_form = ResetPasswordAccountForm.new
    if params[:reset_password_account_form]
      @reset_form = ResetPasswordAccountForm.new(params[:reset_password_account_form])
      if @reset_form.valid?
        results = CsApi::Account.update_password(current_user.username, params[:reset_password_account_form][:passcode], 
          params[:reset_password_account_form][:password])
        if results["success"].eql?('false')
          flash.now[:error] = results["message"]
        else
          current_user.password = Encryptinator.encrypt_string(params[:reset_password_account_form][:password])
          current_user.save
          flash.now[:notice] = results["message"]
        end
      else
        # display the validation messages
      end
    end
  end

  def communities
    @communities = CsApi::Community.all(current_access_token)
  end
  
  def get_account
    @account = CsApi::Member.find_by_membername(current_access_token, @current_user.username, PRETTY_ACCOUNT_MEMBER_FIELDS)
  end
  
end
