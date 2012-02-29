require 'challenges'

class QuizesController < ApplicationController
  
  before_filter :must_be_signed_in, :only => [:show, :answer]
  
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
    Resque.enqueue(ProcessQuickQuizAnswer, current_access_token, current_user.username, params)
    logger.info "[ChallengesController]==== QuickQuiz submission for #{current_user.username} and question #{params['question_id']}"
    render :nothing => true
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
    @today = QuickQuizes.winners_today(current_access_token);
    @last7days = QuickQuizes.winners_last7days(current_access_token);
    @alltime = QuickQuizes.winners_alltime(current_access_token);
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
