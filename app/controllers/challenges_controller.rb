require 'challenges'
require 'time'
require 'settings'
require 'will_paginate/array'

class ChallengesController < ApplicationController
  before_filter :valid_challenge, :only => [:submission, :show, :registrants, :results, :scorecard, :register]
  
  # TODO - rework this section. move into the challenge module
  def register
    @challenge_detail = Challenges.find_by_id(current_access_token, params[:id])[0]
    #see if we need to show them tos different than standard ones
    if @challenge_detail["Terms__c"].eql?('Standard Terms & Conditions')
      Challenges.set_participation_status(current_access_token, current_user.username, params[:id], 'Registered')
      redirect_to(:back)
    # challenge has it's own terms. show and make them register
    else
      @participation_status = signed_in? ? challenge_participation_status : nil
      @terms = Term.find_by_name(@challenge_detail["Terms__c"])
    end
  end
  
  def register_agree_to_tos
    Challenges.set_participation_status(current_access_token, current_user.username, params[:id], 'Registered')
    redirect_to challenge_path
  end
  
  def watch
    Challenges.set_participation_status(current_access_token, current_user.username, params[:id], 'Watching')
    redirect_to(:back)
  end

  def index  
    show_open = false
    show_open = true unless params[:show].eql?('closed')
    orderby = params[:orderby].nil? ? 'name' : params[:orderby]
        
    if params[:keyword].nil?
      @challenges = Challenges.get_challenges(current_access_token, show_open, orderby, params[:category])
    else 
      @challenges = Challenges.get_challenges_by_keyword(current_access_token, params[:keyword])
    end
    @challenges = @challenges.paginate(:page => params[:page] || 1, :per_page => 5) unless @challenges.nil?
  end
  
  def submission_file
    begin
      sanitized = sanitize_filename(params[:file][:file_name].original_filename)
      complete_url = 'https://s3.amazonaws.com/'+ENV['AMAZON_S3_DEFAULT_BUCKET']+'/challenges/'+params[:id]+'/'+sanitized
      AWS::S3::S3Object.store(sanitized, params[:file][:file_name].read, ENV['AMAZON_S3_DEFAULT_BUCKET']+'/challenges/'+params[:id], :access => :public_read)
      # submit the files to sfdc
      submission_results = Challenges.save_submission(current_access_token, 
        params[:file_submission][:participantId], complete_url, params[:file_submission][:comments], 'File')
      if submission_results['Success'].eql?('true')
        flash[:notice] = "File successfully submitted for this challenge."
      else
        flash[:error] = "There was an error submitting your File. Please check it and submit it again."
      end
      redirect_to(:back)
      
    rescue Exception => exc
      render :text => "Couldn't complete the upload: #{exc.message}"
    end
  end  
  
  def submission_url
    submission_results = Challenges.save_submission(current_access_token, 
      params[:url_submission][:participantId], params[:url_submission][:link], params[:url_submission][:comments], 'URL')
    if submission_results['Success'].eql?('true')
      flash[:notice] = "URL successfully submitted for this challenge."
    else
      flash[:error] = "There was an error submitting your URL. Please check it and submit it again."
    end
    redirect_to(:back)
  end  
    
  def submission_url_delete
    submission_results = Challenges.delete_submission(current_access_token, params[:submissionId])
    if submission_results['Success'].eql?('true')
      flash[:notice] = "URL successfully deleted."
    else
      flash[:error] = "There was an error deleting your URL. Please try again."
    end
    redirect_to(:back)
  end
  
  def submission
    @challenge_detail = Challenges.find_by_id(current_access_token, params[:id])[0]
    # do not let them see this page is the challenge has closed
    redirect_to(challenge_url) unless @challenge_detail["Is_Open__c"].eql?('true')
    @participation_status = challenge_participation_status
    @current_submissions = Challenges.current_submissions(current_access_token, @participation_status[:participantId])
  end
  
  def show
    @challenge_detail = Challenges.find_by_id(current_access_token, params[:id])[0]
    @comments = Comments.find_by_challenge(current_access_token, params[:id])
    @participation_status = signed_in? ? challenge_participation_status : nil
  end
  
  def registrants    
    @challenge_detail = Challenges.find_by_id(current_access_token, params[:id])[0]
    @registrants = Challenges.registrants(current_access_token, params[:id])
    @participation_status = signed_in? ? challenge_participation_status : nil
  end
  
  def results
    @challenge_detail = Challenges.find_by_id(current_access_token, params[:id])[0]
    @winners = Challenges.winners(current_access_token, params[:id])
    @participation_status = signed_in? ? challenge_participation_status : nil
  end
  
  def scorecard    
    @challenge_detail = Challenges.find_by_id(current_access_token, params[:id])[0]
    @scorecard_group = Challenges.scorecard_questions(current_access_token, params[:id])
    @participation_status = signed_in? ? challenge_participation_status : nil
  end
  
  def new_comment
    if verify_recaptcha
      post_results = Comments.save(current_access_token, current_user.username, params)
      if post_results['Success'].eql?('true')
        # send an email to all registered and watching members of the new comment post
        Resque.enqueue(NewChallengeCommentSender, current_access_token, params[:id], 
          current_user.username, params[:discussion][:comments]) unless ENV['MAILER_ENABLED'].eql?('false')
      else
        flash[:error] = "There was an error posting your comments. Please try again."
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
    tn = Time.now
    this_month = Time.new(tn.year, tn.month)
    this_year = Time.new(tn.year)
    all_time = Time.new(2000)
    @this_month_leaders = ActiveSupport::JSON.decode(Challenges.get_leaderboard(current_access_token, this_month.iso8601(0),1)["data"])
    @this_year_leaders = ActiveSupport::JSON.decode(Challenges.get_leaderboard(current_access_token, this_year.iso8601(0),1)["data"])
    @all_time_leaders = ActiveSupport::JSON.decode(Challenges.get_leaderboard(current_access_token, all_time.iso8601(0),1)["data"])
    # paginate!!
    @this_month_leaders = @this_month_leaders.paginate(:page => params[:page_month] || 1, :per_page => 2) 
    @this_year_leaders = @this_year_leaders.paginate(:page => params[:page_year] || 1, :per_page => 2) 
    @all_time_leaders = @all_time_leaders.paginate(:page => params[:page_all] || 1, :per_page => 2) 
  end
  
  def recent
    @challenges = Challenges.recent(current_access_token)
  end
  
  # make sure the challenge exists and it is available to show online
  def valid_challenge
    challenge = Challenges.find_by_id(current_access_token, params[:id])[0]
    if challenge.nil?
      redirect_to '/challenges'
    else
      # if the challenge exists, but the start date/time hasn't passed, don't show it
      if Time.parse(challenge["Start_Date__c"]) > Time.now
        redirect_to '/challenges'
      end
    end
  end
  
  private
    
    # iterate through all participants and see if the current user is one of them & get status
    def challenge_participation_status
      status =  {:status => 'Not Registered', :participantId => nil}
      if @challenge_detail["Challenge_Participants__r"]
        @challenge_detail["Challenge_Participants__r"]["records"].each do |record|
          if record["Member__r"]["Name"].eql?(current_user.username) 
            status = {:status => record['Status__c'], :participantId => record['Id']}
            break
          end
        end
      end
      return status
    end
  
    def signed_in?
      !current_user.nil?
    end
    
    def sanitize_filename(file_name)
        just_filename = File.basename(file_name)
        just_filename.sub(/[^\w\.\-]/,'_')
    end
  
end
