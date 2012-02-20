class ProcessQuickQuizAnswer
  include HTTParty 
  
  @queue = :quickquiz_answer_queue
  def self.perform(access_token, username, params)
    # get the question's answer from redis for comparison
    answer = JSON.parse($redis.get("question:#{params["question_id"]}"))    
    # check to see if the answer they submitted matches what's in redis
    if params["answer"].eql?(CGI.unescape(answer["Answer__c"]))
      params["correct"] = "true"
    else
      params["correct"] = "false"
    end
    # save their answer to sfdc
    results = QuickQuizes.save_answer(access_token, username, params)        
  end
  
end