require 'cloud_spokes'
require 'cgi'
class Challenges < Cloudspokes
  
  def self.set_participation_status(access_token, username, id, new_status) 
    
    set_header_token(access_token)
    # get the current status of the user
    current_status = get(ENV['sfdc_rest_api_url']+"/participants/#{esc username}?challengeId=#{id}")
    
    # no record yet... create it with the specified status
    if current_status.length == 0

      options = {
        :body => {
            :username => username,
            :challengeid => id,
            :status__c => new_status
        }
      }

      # create participation record if it doesn't exist         
      results = post(ENV['sfdc_rest_api_url']+'/participants', options)

    # participant record exists... update it with the new status
    else
      results = put(ENV['sfdc_rest_api_url']+"/participants/#{esc username}?challengeid=#{id}&status__c=#{esc new_status}")
    end
    
  end
  
  #this method may go away
  def self.find_by_id(access_token, id) 
    set_header_token(access_token)
    results = get(ENV['sfdc_rest_api_url']+"/challenges/#{id}?comments=true")
  end  

  def self.recent(access_token)  
    set_header_token(access_token)
    results = get(ENV['sfdc_rest_api_url']+'/challenges/recent')
  end
        
  # this method may go away
  def self.get_challenges(access_token, show_open, orderby, category)
    qry_open = show_open ? '&open=true' : '&open=false'
    qry_orderby = "&orderby=#{esc orderby}"
    qry_category = category.nil? ? '' : "&category=#{esc category}"    
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+'/challengesearch?fields=Id,ID__c,Name,Description__c,Top_Prize__c,Registered_Members__c,End_Date__c,Is_Open__c,License__c'+qry_orderby+qry_open+qry_category)
  end
  
  #this method may go away
  def self.get_challenges_by_keyword(access_token, keyword)  
    set_header_token(access_token)
    keyword.gsub!(/'/) { |c| "\\#{c}" }
    get(ENV['sfdc_rest_api_url']+"/challengesearch?fields=Id,ID__c,Name,Description__c,Top_Prize__c,Registered_Members__c,End_Date__c,Is_Open__c&search=#{esc keyword}")
  end
      
  def self.registrants(access_token, id)
    set_header_token(access_token)
    get(ENV['sfdc_rest_api_url']+"/participants?challengeid=#{id}&fields=Member__r.Profile_Pic__c,Member__r.Name,Member__r.Total_Wins__c,Member__r.summary_bio__c,Status__c")
  end
  
  def self.winners(access_token, id)
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+"/participants?challengeid=#{id}&fields=id,name,has_submission__c,place__c,score__c,member__r.name,status__c,money_awarded__c,points_awarded__c,member__r.profile_pic__c,member__r.summary_bio__c&orderby=money_awarded__c%20desc")
  end

  def self.get_leaderboard(access_token, options = {:period => nil, :category => nil})
    set_header_token(access_token) 
    request_url  = ENV['sfdc_rest_api_url'] + '/leaderboard?1=1'
    request_url += ("&period=#{esc options[:period]}") unless options[:period].nil?
    request_url += ("&category=#{esc options[:category]})") unless options[:category].nil?
    leaderboard =  get(request_url)
    #sort by total_money
    leaderboard.sort_by! { |key| key['total_money'].to_i }
    # reverse the order so the largest is at the top
    leaderboard.reverse!
    # add a rank to each one
    rank = 1
    leaderboard.each do |record| 
      record.merge!({'rank' => rank})
      rank = rank + 1
    end
  end
  
  def self.save_submission(access_token, participantId, link, comments, type)
    set_header_token(access_token) 
    
    options = {
      :body => {
          :challenge_participant__c => participantId,
          :url__c => link,
          :type__c => type,
          :comments__c => comments
      }
    }
             
    results = post(ENV['sfdc_rest_api_url']+'/submissions', options)
  end
  
  def self.delete_submission(access_token, submissionId)
    set_header_token(access_token) 
    put(ENV['sfdc_rest_api_url']+"/submissions/#{esc submissionId}?deleted__c=true")
  end
  
  def self.current_submissions(access_token, participantId)
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+"/submissions?participantid=#{esc participantId}")
  end
  
  def self.scorecard_questions(access_token, id)
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+"/scorecard/#{id}/questions")
  end
  
end