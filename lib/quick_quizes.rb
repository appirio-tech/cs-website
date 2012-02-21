require 'cloud_spokes'

class QuickQuizes < Cloudspokes
  
  def self.fetch_10_questions
    get('http://cs-quick-quiz-admin.herokuapp.com/random.json')
  end
  
  def self.save_answer(access_token, username, params)
    set_header_token(access_token)
    
     Rails.logger.info "[QuickQuizes]==== username: #{username}"
     Rails.logger.info "[QuickQuizes]==== :answer: #{params['answer']}"
     Rails.logger.info "[QuickQuizes]==== :correct: #{params['correct']}"
     Rails.logger.info "[QuickQuizes]==== :time: #{params['time']}"
     Rails.logger.info "[QuickQuizes]==== :question_id: #{params['question_id']}"
            
    options = {
      :body => {
          :username => username,
          :answer__c => params['answer'],
          :is_correct__c => params['correct'],
          :time__c => params['time'],
          :quick_quiz_question__c => params['question_id']
      }
    }
    
    Rails.logger.info "[QuickQuizes]==== saving options to sfdc: #{options}"
    
    post('http://www.postbin.org/ni7e2s', options)
    #results = post(ENV['SFDC_REST_API_URL']+'/quickquiz', options)
  end
  
  def self.find_answer_by_id(access_token, id)
    set_header_token(access_token)
    get(ENV['SFDC_REST_API_URL']+"/quickquiz?questionId=#{id}")
  end
  
  def self.winners_today(access_token)
    set_header_token(access_token)
    get(ENV['SFDC_REST_API_URL']+"/quickquiz/results/today")
  end

end


   
