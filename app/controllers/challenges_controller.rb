require 'challenges'
require 'time'
require 'settings'
require 'atomentry'
require 'will_paginate/array'
require 'uri'
require 'json'
include ActionView::Helpers::NumberHelper

class ChallengesController < ApplicationController
  before_filter :check_if_challenge_exists, :only => [:register, :submission, :submission_view_only, :cal, :preview, :show, :registrants, :results, :participant_submissions, :participant_scorecard, :scorecard, :survey]
  before_filter :valid_challenge, :only => [:submission, :show, :registrants, :results, :scorecard, :register, :survey]
  before_filter :must_be_signed_in, :only => [:preview, :review, :register, :watch, :register_agree_to_tos, :submission, :submission_view_only, :new_comment, :toggle_discussion_email]
  before_filter :must_be_open, :only => [:submission_file_upload, :submission_url_upload]  
  before_filter :admin_only, :only => [:all_submissions, :cal, :preview]
  before_filter :redirect_to_http
  
  def register
    @challenge_detail = current_challenge
    determine_page_title
    # if registration is closed redirect them back
    if closed_for_registration?
      flash[:warning] = 'Registration is closed for this challenge.'
      redirect_to challenge_path
    end
    #see if we need to show them tos different than the default standard ones
    if @challenge_detail['Terms_of_Service__r']['Default_TOS__c'].eql?(true)
      Challenges.set_participation_status(current_access_token, current_user.username, params[:id], 'Registered')
      redirect_to(:back)
    # challenge has it's own terms. show and make them register
    else
      @participation_status = challenge_participation_status
      @terms = Terms_of_Service.find(current_access_token, @challenge_detail['Terms_of_Service__r']['Id'])
    end
  end
  
  #these should probably be refactored to ajax calls
  def register_agree_to_tos
    Challenges.set_participation_status(current_access_token, current_user.username, params[:id], 'Registered')
    redirect_to challenge_path
  end
  
  #these should probably be refactored to ajax calls
  def watch
    Challenges.set_participation_status(current_access_token, current_user.username, params[:id], 'Watching')
    redirect_to(:back)
  end

  def index   
    if params[:show].eql?('closed')
      show_open = false
      determine_page_title('Closed Challenges')
    else
      show_open = true
      determine_page_title('Open Challenges')
    end
    @current_order_by = params[:orderby].nil? ? 'name' : params[:orderby]
    @current_order_by_dir = params[:orderby_dir].nil? ? 'asc' : params[:orderby_dir]
    # default closed challenge sorting
    if show_open == false && params[:orderby].nil?
      @current_order_by = 'end_date__c'
      @current_order_by_dir = 'desc'
    end
            
    if params[:keyword].nil?
      @challenges = Challenges.get_challenges(current_access_token, show_open, @current_order_by+'+'+@current_order_by_dir, params[:category])
    else 
      @challenges = Challenges.get_challenges_by_keyword(current_access_token, params[:keyword], show_open)
    end
    @challenges = @challenges.paginate(:page => params[:page] || 1, :per_page => 30) unless @challenges.nil?
    @categories = Categories.all(current_access_token, :select => 'name,color__c', :where => 'true', :order_by => 'display_order__c')

    if @challenges.nil? || @challenges.size == 0
      @challenges_found = false
      if params[:show].eql?('closed')
        flash.now[:warning] = 'No closed challenges found.'
      else
        flash.now[:warning] = "No challenges found. <a href='#{request.fullpath}&show=closed'>Try searching closed challenges</a>.".html_safe
      end
    else
      @challenges_found = true     
      respond_to do |format|
        format.html
        format.json { render :json => @challenges }
      end
    end

  end
  
  def submission_file_upload
    if !params[:file].nil?
      begin
        sanitized = sanitize_filename(params[:file][:file_name].original_filename)
        complete_url = 'https://s3.amazonaws.com/'+ENV['AMAZON_S3_DEFAULT_BUCKET']+'/challenges/'+params[:id]+'/'+current_user.username+'/'+sanitized
        AWS::S3::S3Object.store(sanitized, params[:file][:file_name].read, ENV['AMAZON_S3_DEFAULT_BUCKET']+'/challenges/'+params[:id]+'/'+current_user.username, :access => :public_read)
        # submit the files to sfdc
        submission_results = Challenges.save_submission(current_access_token, 
          params[:file_submission][:participantId], complete_url, params[:file_submission][:comments], 'File')
        if submission_results['Success'].eql?('true')
          flash[:notice] = "File successfully submitted for this challenge."
          # send the race submission notification from jeffdonthemic -- todo: implement a gneric clyde user
          send_race_email_notification(params[:id], 'jeffdonthemic', 'A new submission has been uploaded for this challenge.') if params[:file_submission][:send_race_email]
        else
          flash[:error] = "There was an error submitting your File. Please check it and submit it again."
        end
        redirect_to(:back)
      
      rescue Exception => exc
        render :text => "Couldn't complete the upload: #{exc.message}"
      end
    else
      flash[:error] = "Please ensure that you upload a valid file."
      redirect_to(:back)
    end
  end  
  
  def submission_url_upload
    if uri?(params[:url_submission][:link])
      submission_results = Challenges.save_submission(current_access_token, 
        params[:url_submission][:participantId], params[:url_submission][:link], params[:url_submission][:comments], 'URL')
      if submission_results['Success'].eql?('true')
        flash[:notice] = "URL successfully submitted for this challenge."
      else
        flash[:error] = "There was an error submitting your URL. Please check it and submit it again."
      end
    else
      flash[:error] = "Please enter a valid URL."
    end
    redirect_to(:back)
  end  
    
  def submission_url_delete
    submission_results = Challenges.delete_submission(current_access_token, params[:submissionId])
    if submission_results['Success'].eql?('true')
      flash[:notice] = "Successfully deleted."
    else
      flash[:error] = "There was an error deleting your URL or File. Please try again."
    end
    redirect_to(:back)
  end
  
  def submission
    @challenge_detail = current_challenge
    if @challenge_detail["Is_Open__c"].eql?('true')
      @participation_status = challenge_participation_status
      # if they've not register for the challenge send them to the detail page
      if @participation_status[:participantId].nil?
        redirect_to(challenge_url)
      else
        determine_page_title("Your entry for #{@challenge_detail['Name']}")
        @current_submissions = Challenges.current_submissions(current_access_token, @participation_status[:participantId])
      end
    # if it is closed send them to the view only page
    else
      redirect_to(submission_view_only_url)
    end
  end
  
  def submission_view_only
    @challenge_detail = current_challenge
    @participation_status = challenge_participation_status
    # if they've not register for the challenge send them to the detail page
    if @participation_status[:participantId].nil?
      redirect_to(challenge_url)
    else
      determine_page_title("Your entry for #{@challenge_detail['Name']}")
      @current_submissions = Challenges.current_submissions(current_access_token, @participation_status[:participantId])  
    end
  end
  
  # private appirio page
  def all_submissions
    @all_submissions = Challenges.all_submissions(current_access_token, params[:id])
  end
  
  # private appirio page
  def cal
    @challenge_detail = current_challenge
    @all_submissions = Challenges.all_submissions(current_access_token, params[:id])
  end
  
  def preview
    @challenge_detail = current_challenge
    redirect_to challenge_path if @challenge_detail['Is_Open__c'].eql?('true')
    determine_page_title
  end
  
  def show
    @challenge_detail = current_challenge
    determine_page_title
    @comments = Comments.find_by_challenge(current_access_token, params[:id])
    @participation_status = challenge_participation_status
    @use_captcha = use_captcha? if signed_in?
    
    # grab some extra data for quickquizes
    if @challenge_detail["Challenge_Type__c"].eql?('Quick Quiz')   
      @todays_results = QuickQuizes.winners_today(current_access_token, params[:id], 'all');
      # get the current member's status for the challenge
      @member_status = signed_in? ? QuickQuizes.member_status_today(current_access_token, params[:id], current_user.username) : nil
    end
    
    respond_to do |format|
      if @challenge_detail["Challenge_Type__c"].eql?('Quick Quiz')
        format.html { render "show_quickquiz" }
      else
        format.html 
      end
      format.json { render :json => @challenge_detail }
    end
  end
  
  def toggle_discussion_email
    Challenges.toggle_discussion_emails_status(current_access_token, current_user.username, params[:id])
    if challenge_participation_status[:send_discussion_emails] == false
      flash[:notice] = "No problem. We've removed you from the Discussion board distribution list for this challenge. You can always subscribe again at the bottom of this page."
    else
      flash[:notice] = "OK! We've added you to the Discussion board distribution list for this challenge. You will receive an email any time someone posts to the Discussion board."
    end
    redirect_to challenge_path(params[:id])
  end
    
  def registrants    
    @challenge_detail = current_challenge
    determine_page_title("Registrants for #{@challenge_detail['Name']}")
    @registrants = Challenges.registrants(current_access_token, params[:id])
    @registrants = @registrants.paginate(:page => params[:page] || 1, :per_page => 50) unless @registrants.nil?
    @participation_status = challenge_participation_status
    respond_to do |format|
      format.html
      format.json { render :json => @registrants }
    end
  end
  
  def results
    @challenge_detail = current_challenge
    if !@challenge_detail['Status__c'].eql?('Winner Selected')
      flash[:notice] = "No winners available at this time."
      redirect_to challenge_path
    else
      determine_page_title("Results for #{@challenge_detail['Name']}")
      @participants = Challenges.scorecards(current_access_token, params[:id])
      @participation_status = challenge_participation_status    
      @has_submission = signed_in? ? @participation_status[:has_submission] : false
      respond_to do |format|
        format.html
        format.json { render :json => @participants }
      end
    end
  end  
  
  def participant_submissions
    @challenge_detail = current_challenge
    determine_page_title
    @participation_status = challenge_participation_status    
    # if the current user did not submit for the challenge, they cannot see this page
    redirect_to challenge_path unless @participation_status[:has_submission]
    @all_submissions = Challenges.all_submissions(current_access_token, params[:id])
    @all_submissions.each do |participant| 
      if participant['Challenge_Participant__c'].eql?(params[:participant])
        @participant_name = participant['Username__c']
      end 
    end
  end
  
  def participant_scorecard
    @challenge_detail = current_challenge
    determine_page_title
    @participants = Challenges.scorecards(current_access_token, params[:id])
    @participation_status = challenge_participation_status
    scorecard = Scoring.scorecard(current_access_token, params[:scorecard], params[:reviewer]).to_json
    # set the json results to be html safe are usable in the javascript
    @json = scorecard[scorecard.index('['),scorecard.length].gsub(']}',']').html_safe
  end
  
  def scorecard    
    @challenge_detail = current_challenge
    determine_page_title("Scorecard for #{@challenge_detail['Name']}")
    @scorecard_group = Challenges.scorecard_questions(current_access_token, params[:id])
    @participation_status = challenge_participation_status
  end
  
  def survey    
    @challenge_detail = current_challenge
    determine_page_title
    @participation_status = challenge_participation_status
    if params["survey"]
      post_results = Surveys.save(current_access_token, params[:id], params["survey"])
      flash[:notice] = "Thanks for completing the survey!" 
      redirect_to challenge_path     
    end
  end
  
  def new_comment    
    # capture their comments so we can show them again if recaptcha error
    session[:captcha_comments] = params[:discussion][:comments]
    # get their status so we can determine whether or not to show captcha
    @participation_status = challenge_participation_status
    # if their captcha was valid OR no need to use captcha
    if verify_recaptcha || !use_captcha?
      if params[:discussion][:comments].length > 2000
        flash[:error] = "Comments cannot be longer than 2000 characters. Please try again."        
      else  
        post_results = Comments.save(current_access_token, current_user.username, params)
        if post_results['Success'].eql?('true')
          # delete their comments in the session if it exists for a failed attempt
          session.delete(:captcha_comments) unless session[:captcha_comments].nil?
          # if they are replying to a certain message use that else, use the new message id from sfdc
          reply_to = params[:discussion][:reply_to].empty? ? post_results['Message'] : params[:discussion][:reply_to]
          # send an email to all registered members of the new comment post
          Resque.enqueue(NewChallengeCommentSender, current_access_token, params[:id], 
            current_user.username, params[:discussion][:comments], reply_to) unless ENV['MAILER_ENABLED'].eql?('false')
        else
          flash[:error] = "There was an error posting your comments. Please try again."
        end
      end
      redirect_to(:back)
      
    else
      flash[:error] = "There was an error with the recaptcha code below. Please resubmit your comment." 
      # delete the recaptcha flash that shows up incorrectly!!
      flash.delete(:recaptcha_error)
      redirect_to(:back)
    end
  end
  
  def leaderboard
    determine_page_title('Challenge Leaderboards')
    @this_month_leaders = Challenges.get_leaderboard(current_access_token, :period => 'month', :category => params[:category] || nil, :limit => 1000)
    @this_year_leaders = Challenges.get_leaderboard(current_access_token, :period => 'year', :category => params[:category] || nil, :limit => 1000)
    @all_time_leaders = Challenges.get_leaderboard(current_access_token, :category => params[:category] || nil, :limit => 1000)
    # paginate!!
    @this_month_leaders = @this_month_leaders.paginate(:page => params[:page_month] || 1, :per_page => 10) 
    @this_year_leaders = @this_year_leaders.paginate(:page => params[:page_year] || 1, :per_page => 10) 
    @all_time_leaders = @all_time_leaders.paginate(:page => params[:page_all] || 1, :per_page => 10) 
    @categories = Categories.all(current_access_token, :select => 'name,color__c', :where => 'true', :order_by => 'display_order__c')
    respond_to do |format|
      format.html
      format.json { render :json => @this_month_leaders }
    end
  end
  
  def leaderboard_this_month
    determine_page_title('Challenge Leaderboard - This Month')
    @this_month_leaders = Challenges.get_leaderboard(current_access_token, :period => 'month', :category => params[:category] || nil, :limit => 1000)
    @this_month_leaders = @this_month_leaders.paginate(:page => params[:page] || 1, :per_page => 10) 
    @categories = Categories.all(current_access_token, :select => 'name,color__c', :where => 'true', :order_by => 'display_order__c')
    respond_to do |format|
      format.html { render :text => "JSON is only supported for this method." }
      format.json { render :json => { "leaders" => @this_month_leaders, "categories" => @categories } }
    end
  end  
  
  # leaderboard_this_year.json?category=Salesforce.com&page=3&per_page=20
  def leaderboard_this_year
    determine_page_title('Challenge Leaderboard - This Year')
    @this_year_leaders = Challenges.get_leaderboard(current_access_token, :period => 'year', :category => params[:category] || nil, :limit => 1000)
    @this_year_leaders = @this_year_leaders.paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 10) 
    @categories = Categories.all(current_access_token, :select => 'name,color__c', :where => 'true', :order_by => 'display_order__c')
    respond_to do |format|
      format.html { render :text => "JSON is only supported for this method." }
      format.json { render :json => { "leaders" => @this_year_leaders, "categories" => @categories } }
    end
  end
  
  def leaderboard_all_time
    determine_page_title('Challenge Leaderboard - All Time')
    @all_time_leaders = Challenges.get_leaderboard(current_access_token, :category => params[:category] || nil, :limit => 1000)
    @all_time_leaders = @all_time_leaders.paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 10) 
    @categories = Categories.all(current_access_token, :select => 'name,color__c', :where => 'true', :order_by => 'display_order__c')
    respond_to do |format|
      format.html { render :text => "JSON is only supported for this method." }
      format.json { render :json => { "leaders" => @all_time_leaders, "categories" => @categories } }
    end
  end
  
  def recent
    determine_page_title('Recently Completed Challenges')
    @challenges = Challenges.recent(current_access_token)
    respond_to do |format|
      format.html
      format.json { render :json => @challenges }
    end
  end
  
  def feed
    show_open = false
    show_open = true unless params[:show].eql?('closed')                
    challenges = Challenges.get_challenges(current_access_token, show_open, 'name+asc', params[:category])  
    @feed_items = Array.new  
        
    if show_open == false
      @feed_title = params[:category].nil? ? "Closed CloudSpokes Challenges" : "Closed #{params[:category]} CloudSpokes Challenges"
    else  
      @feed_title = params[:category].nil? ? "Open CloudSpokes Challenges" : "Open #{params[:category]} CloudSpokes Challenges"
    end
    
    unless challenges.nil?      
      challenges.each do |challenge|
        entry = AtomEntry.new(:id => challenge['Challenge_Id__c'], :title => challenge['Name'], 
          :content => challenge['Description__c'], :start_date => challenge['Start_Date__c'],
          :end_date => challenge['End_Date__c'], :top_prize => number_to_currency(challenge['Total_Prize_Money__c'], :precision => 0), :categories => challenge['Challenge_Categories__r'])
        @feed_items.push(entry)
      end
    end

    respond_to do |format|
      format.atom { render :layout => false }
      # we want the RSS feed to redirect permanently to the ATOM feed
      format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
    end
  end  
  
  def feed_recent
    challenges = Challenges.recent(current_access_token)
    @feed_title = "Recently Completed CloudSpokes Challenges"
    
    @feed_items = Array.new    
    challenges.each do |challenge|
      entry = AtomEntry.new(:id => challenge['Challenge_Id__c'], :title => challenge['Name'], 
        :content => challenge['Description__c'], :end_date => challenge['End_Date__c'], 
        :top_prize => number_to_currency(challenge['Total_Prize_Money__c'], :precision => 0), :categories => challenge['Challenge_Categories__r'])
      @feed_items.push(entry)
    end

    respond_to do |format|
      format.atom { render :layout => false }
      # we want the RSS feed to redirect permanently to the ATOM feed
      format.rss { redirect_to feed_recent_path(:format => :atom), :status => :moved_permanently }
    end
  end
  
  # make sure the challenge exists and it is available to show online
  def valid_challenge
    if current_challenge.nil?
      redirect_to '/challenges'
    else
      # if the challenge exists, but the start date/time hasn't passed or it's the wrong status, don't show it
      if Time.parse(current_challenge["Start_Date__c"]) > Time.now || current_challenge["Status__c"].eql?('Hidden') || 
          current_challenge["Status__c"].eql?('Planned')
        redirect_to '/challenges'
      end
    end
  end

  # if the challenge is no longer open, then send them back to the challenge page
  def must_be_open
    if current_challenge["Is_Open__c"].eql?('false')
      flash[:error] = "Sorry... this challenge has ended."
      redirect_to challenge_path
    end
  end
  
  # if not signed in, then send them back to the challenge page
  def must_be_signed_in
    if !signed_in?
      session[:redirect_to_after_auth] = request.fullpath
      flash[:error] = "Sorry... the page you were trying to access requires you to be logged in first."
      redirect_to login_url
    end
  end
  
  # if signed in, must have an @appirio.com email address or be in the same account as the challenge sponsor
  def admin_only
    if signed_in?        
      if !current_user.accountid.nil?
        sponsor = current_user.accountid.eql?(current_challenge['Account__c']) ? true : false
      end
          
      if !appirio_user? && !sponsor
        redirect_to challenge_path
      end
    else
      redirect_to challenge_path
   end
  end

  def check_if_challenge_exists
    render :file => "#{Rails.root}/public/challenge-not-found.html", :status => :not_found if current_challenge.nil?
    # check for an error thrown by sfdc if they request a 'bad' challenge (e.g., /challenges/fasdaf). sfdc returns an object.
    raise ActionController::RoutingError.new('Bad challenge request.') if !current_challenge.nil? && current_challenge.has_key?('errorCode') 
  end
  
  def closed_for_registration?
    @challenge_detail['Registration_End_Date__c'].nil? ? false : Time.parse(@challenge_detail['Registration_End_Date__c']).past?
  end
  
  def current_challenge
    @current_challenge ||= Challenges.find_by_id(current_access_token, params[:id])[0] 
  end
  
  # most of the time the title will be the challenge name but be flexible
  def determine_page_title(title=nil)
    if title.nil?
      unless @challenge_detail.nil?
        @page_title = @challenge_detail["Name"]
      end
    else
      @page_title = title
    end  
  end
  
  private

    def send_race_email_notification(id, username, email_text)
      # corrent the correct params hash
      discussion = {:comments => email_text, :reply_to => ''}
      params = {:discussion => discussion, :id => id}
      # add the comment into the sfdc
      post_results = Comments.save(current_access_token, username, params)
      # send an email to all registered members of the new comment post
      Resque.enqueue(NewChallengeCommentSender, current_access_token, id, 
        username, email_text, post_results['Message']) if ENV['MAILER_ENABLED'].eql?('true') &&  post_results['Success'].eql?('true')
    end

    def use_captcha?
      if appirio_user?
        false
      else
        @participation_status[:total_valid_submissions].eql?(0) ? true : false
      end
    end
    
    def challenge_participation_status
      if signed_in?      
        participation = Challenges.participant_status(current_access_token, current_user.username, params[:id])[0]
        if participation.nil?
          status =  {:status => 'Not Registered', :participantId => nil, :has_submission => false, 
            :send_discussion_emails => false, :total_valid_submissions => 0}
        else
          status =  {:status => participation["Status__c"], :participantId => participation["Id"], 
            :has_submission => participation["Has_Submission__c"], 
            :send_discussion_emails => participation["Send_Discussion_Emails__c"],
            :total_valid_submissions => participation["Member__r"]["Valid_Submissions__c"].to_i}
        end
      else 
        status =  nil
      end
    end
  
    def signed_in?
      !current_user.nil?
    end
    
    def sanitize_filename(file_name)
        just_filename = File.basename(file_name)
        just_filename.sub(/[^\w\.\-]/,'_')
    end
    
    def uri?(string)
      uri = URI.parse(string)
      %w( http https ).include?(uri.scheme)
    rescue URI::BadURIError
      false
    end
  
end
