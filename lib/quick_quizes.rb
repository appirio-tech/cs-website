require 'cloud_spokes'

class QuickQuizes < Cloudspokes
  
  #
  # Returns a single quick quiz questions from sfdc by type and challenge
  # * *Args*    :
  #   - access_token -> the current user's access_token
  #   - username -> the current user's username
  #   - challengeId -> the id of the challegenge they are requesting a question for
  #   - type -> the type of question they are requesting (random, java, ruby, etc)
  # * *Returns* :
  #   - JSON containing success, questionNbr, message and Quick_Quiz__c object
  # * *Raises* :
  #   - ++ ->
  #
  def self.fetch_question(access_token, username, challengeId, type)
    set_header_token(access_token)
    get(ENV['SFDC_REST_API_URL']+"/quickquiz/#{esc username}?type=#{esc type}&challengeId=#{challengeId}")  
  end
  
  #
  # Saves a quick quiz question to sfdc created by a member
  # * *Args*    :
  #   - access_token -> the current user's access_token
  #   - username -> the current user's username
  #   - params -> hash containing the question data to save
  # * *Returns* :
  #   - JSON containing success, message and the id of the question created
  # * *Raises* :
  #   - ++ ->
  #  
  def self.save_question(access_token, username, params)
    # map the form field names to their sfdc field names
    sfdc_params = {"question" => "question__c", "answer" => "answerprettyprint__c", "author_comments" => "author_notes__c", "type" => "type__c"}
    #convert the hash names to sfdc
    converted = Hash[params.map {|k, v| [sfdc_params[k], v] }]
    
    set_header_token(access_token)    
    options = {
      :body => converted.to_json
    }
    results = post(ENV['SFDC_REST_API_URL']+'/quickquiz/admin/questions', options)
    return results['success']
  end
  
  #
   # Saves a quick quiz question to sfdc created by a member
   # * *Args*    :
   #   - access_token -> the current user's access_token
   #   - username -> the current user's username
   #   - params -> hash containing the question data to save
   # * *Returns* :
   #   - JSON containing success, message and the id of the question created
   # * *Raises* :
   #   - ++ ->
   #  
   def self.update_question(access_token, username, params)
     # map the form field names to their sfdc field names
     sfdc_params = {"question" => "question__c", "answer" => "answerprettyprint__c", 
       "reviewer_comments" => "reviewer_notes__c", "type" => "type__c", "id" => "id", "status" => "status__c"}
     #convert the hash names to sfdc
     converted = Hash[params.map {|k, v| [sfdc_params[k], v] }]

     set_header_token(access_token)    
     options = {
       :body => converted.to_json
     }
     results = put(ENV['SFDC_REST_API_URL']+'/quickquiz/admin/questions', options)
   end
  
  #
  # Returns a collection of quick quiz questions for a member to review
  # * *Args*    :
  #   - access_token -> the current user's access_token
  #   - username -> the current user's username
  # * *Returns* :
  #   - collection of quick_quiz questions
  # * *Raises* :
  #   - ++ ->
  #  
  def self.review_questions(access_token, username)
    set_header_token(access_token)
    get(ENV['SFDC_REST_API_URL']+'/quickquiz/admin/questions')
  end
  
  #
  # Returns a single quick quiz question to be reviewed
  # * *Args*    :
  #   - access_token -> the current user's access_token
  #   - id -> the id of the quick quiz questions
  # * *Returns* :
  #   - a quick quiz question
  # * *Raises* :
  #   - ++ ->
  #  
  def self.review_question(access_token, id)
    set_header_token(access_token)
    get(ENV['SFDC_REST_API_URL']+'/quickquiz/admin/questions?RecordId='+id)['records'][0]
  end  
  
  # ---- NO LONGER BEING USED ----
  def self.fetch_10_questions(type=nil)
    if type.nil?
      get(ENV['QUICK_QUIZ_QUESTIONS_URL']+'/random.json')
    else
      get("#{ENV['QUICK_QUIZ_QUESTIONS_URL']}/random.json/#{type}")
    end
  end
  
  #
  # PUTS an answer to SFDC
  # * *Args*    :
  #   - access_token -> the current user's access_token
  #   - username -> the name of the user answering the question
  #   - params -> the params contain the question id and answer
  # * *Returns* :
  #   - null
  # * *Raises* :
  #   - ++ ->
  #
  def self.save_answer(access_token, username, params)
    set_header_token(access_token)
    put(ENV['SFDC_REST_API_URL']+"/quickquiz?quick_quiz_question__c=#{params['question_id']}&username=#{esc username}&answer__c=#{esc params['answer']}&challengeId=#{params['id']}")
  end
  
  def self.find_answer_by_id(access_token, id)
    set_header_token(access_token)
    get(ENV['SFDC_REST_API_URL']+"/quickquiz?questionId=#{id}")
  end
  
  def self.winners_today(access_token, id, type=nil)
    set_header_token(access_token)
    get(ENV['SFDC_REST_API_URL']+"/quickquiz/#{id}/results/today?type=#{type}")
  end
  
  def self.winners_last7days(access_token, id, type=nil)
    set_header_token(access_token)
    get(ENV['SFDC_REST_API_URL']+"/quickquiz/#{id}/results/last7days?type=#{type}")
  end
  
  def self.winners_alltime(access_token, id, type=nil)
    set_header_token(access_token)
    get(ENV['SFDC_REST_API_URL']+"/quickquiz/#{id}/results/alltime?type=#{type}")
  end
  
  def self.member_status_today(access_token, id, username)
    set_header_token(access_token)
    results = get(ENV['SFDC_REST_API_URL']+"/quickquiz/#{id}/member/#{esc username}")
  end
  
  def self.member_results_today(access_token, id, username)
    set_header_token(access_token)
    get(ENV['SFDC_REST_API_URL']+"/quickquiz/#{id}/answers/#{esc username}")
  end
  
  def self.member_results_by_date(access_token, id, username, dt)
    set_header_token(access_token)
    get(ENV['SFDC_REST_API_URL']+"/quickquiz/#{id}/#{esc username}/dailyresults/#{dt}")
  end

  def self.member_answer(access_token, email, id)
    set_header_token(access_token)
    get(ENV['SFDC_REST_API_URL']+"/quickquiz/#{esc email}/answer/#{id}")
  end
  
  def self.all_winners(access_token, id)
    set_header_token(access_token)
    get(ENV['SFDC_REST_API_URL']+"/quickquiz/#{id}/winners")
  end
  
  def self.flag_answer(access_token, id)
    set_header_token(access_token)
    put(ENV['SFDC_REST_API_URL']+"/quickquiz/answer/flag/#{esc id}")
  end

end


   
