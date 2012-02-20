class ProcessQuickQuizAnswer
  include HTTParty 
  
  @queue = :quickquiz_answer_queue
  def self.perform(access_token, username, params)

    Rails.logger.info "[Resque]==== in the worker"
    
    Rails.logger.info "[Resque]==== answer params: #{params}"
    Rails.logger.info "[Resque]==== redis: #{$redis}"
    
    # get the question's answer from redis
    answer = JSON.parse($redis.get("question:#{params["question_id"]}"))
    
    Rails.logger.info "[Resque]==== answer from redis: #{answer}"
    
    # check to see if the answer they submitted matches what's in redis
    if params["answer"].eql?(CGI.unescape(answer["Answer__c"]))
      params["correct"] = "true"
    else
      params["correct"] = "false"
    end
    # save their answer to sfdc
    results = QuickQuizes.save_answer(access_token, username, params)

    Rails.logger.info "[Resque]==== done saving answer"
    
    Rails.logger.info "[Resque]==== save_answer results: #{results}"
        
  end
  
end