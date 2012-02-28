class ProcessQuickQuizAnswer
  include HTTParty 
  
  @queue = :quickquiz_answer_queue
  def self.perform(access_token, username, params)
    
    if params.has_key?('answer')
    
      # get the question's answer from redis for comparison
      answer = JSON.parse($redis.get("question:#{params["question_id"]}"))    
      # check to see if the answer they submitted matches what's in redis
      if params["answer"].eql?(CGI.unescape(answer["Answer__c"]))
        params["correct"] = "true"
      else
        params["correct"] = "false"
      end
      Rails.logger.info "[Resque]==== QuickQuiz submission for #{username} and question #{params["question_id"]} being evaluted: #{params["correct"]}"
    end
    
    # save their answer to sfdc. the class determines whether to POST or PUT
    results = QuickQuizes.save_answer(access_token, username, params)  
    Rails.logger.info "[Resque]==== QuickQuiz submission for #{username} and question #{params["question_id"]}. Results: #{results}"
    
  end
  
end