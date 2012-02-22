require 'cloud_spokes'
require 'cgi'
class Challenges < Cloudspokes
  
  def self.participant_status(access_token, username, id) 
    set_header_token(access_token)
    # get the current status of the user
    current_status = get(ENV['SFDC_REST_API_URL']+"/participants/#{esc username}?challengeId=#{id}")
  end
  
  def self.set_participation_status(access_token, username, id, new_status) 
    
    set_header_token(access_token)
    # get the current status of the user
    current_status = get(ENV['SFDC_REST_API_URL']+"/participants/#{esc username}?challengeId=#{id}")
    
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
      results = post(ENV['SFDC_REST_API_URL']+'/participants', options)

    # participant record exists... update it with the new status
    else
      results = put(ENV['SFDC_REST_API_URL']+"/participants/#{esc username}?challengeid=#{id}&status__c=#{esc new_status}")
    end
    
  end
  
  #this method may go away
  def self.find_by_id(access_token, id) 
    set_header_token(access_token)
    results = get(ENV['SFDC_REST_API_URL']+"/challenges/#{id}?comments=true")
  end  
  
  def self.find_by_sql_id(access_token, id) 
    set_header_token(access_token)
    get(ENV['SFDC_REST_API_URL']+"/challengesqlid/#{id}")
  end

  def self.recent(access_token)  
    set_header_token(access_token)
    results = get(ENV['SFDC_REST_API_URL']+'/challenges/recent')
  end
        
  # this method may go away
  def self.get_challenges(access_token, show_open, orderby, category)
    qry_open = show_open ? '&open=true' : '&open=false'
    qry_orderby = "&orderby=#{esc orderby}"
    qry_category = category.nil? ? '' : "&category=#{esc category}"    
    set_header_token(access_token) 
    get(ENV['SFDC_REST_API_URL']+'/challengesearch?fields=Id,Challenge_Id__c,Name,Description__c,Top_Prize__c,Registered_Members__c,Start_Date__c,End_Date__c,Is_Open__c,License__c'+qry_orderby+qry_open+qry_category)
  end
  
  #this method may go away
  def self.get_challenges_by_keyword(access_token, keyword, show_open)  
    set_header_token(access_token)
    keyword.gsub!(/'/) { |c| "\\#{c}" }
    get(ENV['SFDC_REST_API_URL']+"/challengesearch?fields=Id,Challenge_Id__c,Name,Description__c,Top_Prize__c,Registered_Members__c,End_Date__c,Is_Open__c&search=#{esc keyword}&open=#{show_open}")
  end
      
  def self.registrants(access_token, id)
    set_header_token(access_token)
    get(ENV['SFDC_REST_API_URL']+"/participants?challengeid=#{id}&fields=Member__r.Profile_Pic__c,Member__r.Name,Member__r.Total_Wins__c,Member__r.summary_bio__c,Status__c,has_submission__c&limit=250&orderby=member__r.name")
  end
  
  def self.winners(access_token, id)
    set_header_token(access_token) 
    get(ENV['SFDC_REST_API_URL']+"/participants?challengeid=#{id}&fields=id,name,has_submission__c,place__c,score__c,member__r.name,status__c,money_awarded__c,points_awarded__c,member__r.profile_pic__c,member__r.summary_bio__c&orderby=money_awarded__c%20desc")
  end
  
  def self.scorecards(access_token, id) 
    set_header_token(access_token)
    results = get(ENV['SFDC_REST_API_URL']+"/challenges/#{id}/scorecards")
  end

  def self.get_leaderboard(access_token, options = {:period => nil, :category => nil, :limit => nil})
    set_header_token(access_token) 
    request_url  = ENV['SFDC_REST_API_URL'] + '/leaderboard?1=1'
    request_url += ("&period=#{esc options[:period]}") unless options[:period].nil?
    request_url += ("&category=#{esc options[:category]}") unless options[:category].nil?
    request_url += ("&limit=#{options[:limit]}") unless options[:limit].nil?
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
             
    results = post(ENV['SFDC_REST_API_URL']+'/submissions', options)
  end
  
  def self.delete_submission(access_token, submissionId)
    set_header_token(access_token) 
    put(ENV['SFDC_REST_API_URL']+"/submissions/#{esc submissionId}?deleted__c=true")
  end
  
  def self.current_submissions(access_token, participantId)
    set_header_token(access_token) 
    get(ENV['SFDC_REST_API_URL']+"/submissions?participantid=#{esc participantId}")
  end
  
  def self.all_submissions(access_token, challengeId)
    set_header_token(access_token) 
    get(ENV['SFDC_REST_API_URL']+"/submissions?challengeid=#{challengeId}&orderby=username__c")
  end
  
  def self.scorecard_questions(access_token, id)
    set_header_token(access_token) 
    get(ENV['SFDC_REST_API_URL']+"/scorecard/#{id}/questions")
  end
  
end