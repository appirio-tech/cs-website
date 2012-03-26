require 'challenges'

class QuizesController < ApplicationController
  
  before_filter :must_be_signed_in
  
  def show
    # check if the challenge is still open
    challenge_detail = Challenges.find_by_id(current_access_token, ENV['QUICK_QUIZ_CHALLENGE_ID'])[0]
    if challenge_detail["Is_Open__c"].eql?("false")
      flash[:notice] = "Sorry... we are no longer accepting entries for this challenge."
      redirect_to quizleaderboard_path
    end
    # see this the member has already entered for today
    member_status = QuickQuizes.member_status_today(current_access_token, current_user.username)
    if member_status.size > 0
      flash[:notice] = "You have already submitted for today."
      redirect_to quizleaderboard_path
    end

    # if they are not registered for the challenge, then send them back to the challenge page
    redirect_to challenge_path(ENV['QUICK_QUIZ_CHALLENGE_ID']) unless challenge_participation_status[:status].eql?('Registered')
    @questions = QuickQuizes.fetch_10_questions(params[:type])
  end

  def answer
    logger.info "[ChallengesController]==== QuickQuiz question #{params['question_id']} received in controller"
    results = Resque.enqueue(ProcessQuickQuizAnswer, current_access_token, current_user.username, params)
    logger.info "[ChallengesController]==== QuickQuiz results to queue: #{results}"
    logger.info "[ChallengesController]==== QuickQuiz submission for #{current_user.username} and question #{params['question_id']} and status is #{params['p']}"
    render :nothing => true
  end

  def winners
    @challenge_detail = Challenges.find_by_id(current_access_token, ENV['QUICK_QUIZ_CHALLENGE_ID'])[0]
    @todays_results = QuickQuizes.winners_today(current_access_token, 'all');  
    @winners = QuickQuizes.all_winners(current_access_token);
    @days = []
    @winners.each do |record|
      @days.push(record["Quiz_Date__c"]) unless @days.include?(record["Quiz_Date__c"])
    end
    respond_to do |format|
      format.html
      format.json { render :json => @winners }
    end
  end
  
  def results
    @challenge_detail = Challenges.find_by_id(current_access_token, ENV['QUICK_QUIZ_CHALLENGE_ID'])[0]
    # see if they have participated for the today
    member_status = QuickQuizes.member_status_today(current_access_token, current_user.username)
    if member_status.empty?
      flash[:notice] = "There are no results for you today."
      redirect_to quizleaderboard_path
    else
      @results = member_status[0]
      @answers = QuickQuizes.member_results_today(current_access_token, current_user.username)
      @todays_results = QuickQuizes.winners_today(current_access_token, 'all');  
    end
  end
  
  def results_by_member
    @challenge_detail = Challenges.find_by_id(current_access_token, ENV['QUICK_QUIZ_CHALLENGE_ID'])[0]
    @todays_results = QuickQuizes.winners_today(current_access_token, 'all'); 
    results = QuickQuizes.member_results_by_date(current_access_token, params[:member], params[:date])
    if results['success'].eql?('true')
      @answers = results['records']
      flash.now[:warning] = "There are no results for #{params[:member]} for this date. Try changing the username or date in the URL." unless @answers.size > 0
    else
      @answers = []
      flash.now[:error] = "#{results['message']}"
    end    
  end
  
  def answer_by_member
    result = QuickQuizes.member_answer(current_access_token, current_user.email, params[:id])
    if !result['records'].empty?
      @incorrect = result['records'][0]['Quick_Quiz_Question__r']['Question__c'].html_safe
      @correct = result['records'][0]['Quick_Quiz_Question__r']['AnswerPrettyPrint__c'].html_safe
      @type = result['records'][0]['Type__c'].html_safe
    end
    render :layout => "blank"
  end
  
  # this isn't working
  def results_live
    @challenge_detail = Challenges.find_by_id(current_access_token, ENV['QUICK_QUIZ_CHALLENGE_ID'])[0]
    @todays_results = QuickQuizes.winners_today(current_access_token, 'all');  
  end

  def practice
    # check if the challenge is still open
    challenge_detail = Challenges.find_by_id(current_access_token, ENV['QUICK_QUIZ_CHALLENGE_ID'])[0]
    if challenge_detail["Is_Open__c"].eql?("false")
      flash[:notice] = "Sorry... we are no longer accepting entries for this challenge."
      redirect_to quizleaderboard_path
    end
    @questions = YAML.load_file(File.join(::Rails.root, 'vendor/assets', 'practice_qq_json.yml'))
  end

  def leaderboard
    # get the categories for the challenge
    params[:type] = 'Random' unless !params[:type].nil?
    @challenge_detail = Challenges.find_by_id(current_access_token, ENV['QUICK_QUIZ_CHALLENGE_ID'])[0]
    @today = QuickQuizes.winners_today(current_access_token, params[:type]);
    @last7days = QuickQuizes.winners_last7days(current_access_token, params[:type]);
    @alltime = QuickQuizes.winners_alltime(current_access_token, params[:type]);
  end
  
  # if signed in, then send them back to the challenge page
  def must_be_signed_in
    if !signed_in?
      redirect_to challenge_path(ENV['QUICK_QUIZ_CHALLENGE_ID'])
    end
  end
  
  private
  
    # TODO - THIS NEEDS TO BE REFACTORED AS THIS METHOD IS ALSO IN THE CHALLENGES CONTROLLER -- but hardcoded quiz id
    def challenge_participation_status
      if signed_in?      
        participation = Challenges.participant_status(current_access_token, current_user.username, ENV['QUICK_QUIZ_CHALLENGE_ID'])[0]
        if participation.nil?
          status =  {:status => 'Not Registered', :participantId => nil, :has_submission => false}
        else
          status =  {:status => participation["Status__c"], :participantId => participation["Id"], 
            :has_submission => participation["Has_Submission__c"]}
        end
      else 
        status =  nil
      end
    end
  
    def signed_in?
      !current_user.nil?
    end

end
