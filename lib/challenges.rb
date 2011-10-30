require 'cloud_spokes'
class Challenges < Cloudspokes
  
  #this member may go away
  def self.find_by_id(access_token, id)  
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+'/challenges?fields=Id,Name,Additional_Info__c,Comments__c,Contest_Image__c,Contest_Logo__c,Description__c,End_Date__c,Is_Open__c,Prize_Type__c,Release_to_Open_Source__c,Requirements__c,ID__c,Start_Date__c,Status__c,Submission_Badge__c,Submission_Details__c,Terms__c,Usage_Details__c,Winner_Announced__c,Registered_Members__c,Total_Prize_Money__c,Top_Prize__c&id__c='+id)
  end  
  
  def self.user_participation_status(access_token, username, id)
    set_header_token(access_token) 
    results = get(ENV['sfdc_rest_api_url']+'/participants?challengeid='+id+'&membername='+username)
    if results.length > 0
      return {:status => results[0]['Status__c'], :participantId => results[0]['Id']}
    else
      return {:status => 'Not Registered', :participantId => nil}
    end
  end
  
  # add a member as a participant and update to 'watch'
  def self.update_participation_status(access_token, username, id, status)
    
    options = {
      :body => {
          :username => username,
          :challengeid => id
      }
    }
    
    # try and create participation record if it doesn't exist         
    results = post(ENV['sfdc_rest_api_url']+'/participants', options)
    if results['Success'].eql?('true')
      # now update with status of 'watch'. use the id returned from the post in the message
      put(ENV['sfdc_rest_api_url']+'/participants/'+results['Message']+'?status__c='+status, options)
    end
  end
  
  # add a member as a participant
  def self.register(access_token, username, id)
    
    options = {
      :body => {
          :username => username,
          :challengeid => id
      }
    }
             
    post(ENV['sfdc_rest_api_url']+'/participants', options)
    
  end
    
  # this method may go away
  def self.get_challenges(access_token, show_open, orderby, category)
    
    qry_open = show_open ? '&open=true' : '&open=false'
    qry_orderby = '&orderby='+orderby
    qry_category = category.nil? ? '' : '&category='+CGI::escape(category)
    
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+'/challengesearch?fields=Id,ID__c,Name,Description__c,Top_Prize__c,Registered_Members__c,End_Date__c,Is_Open__c'+qry_orderby+qry_open+qry_category)
  end
  
  #this member may go away
  def self.get_challenges_by_keyword(access_token, keyword)  
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+'/challengesearch?fields=Id,ID__c,Name,Description__c,Top_Prize__c,Registered_Members__c,End_Date__c,Is_Open__c&search='+keyword)
  end
    
  def self.get_categories(access_token, id)
    set_header_token(access_token) 
    catnames = []
    cats = get(ENV['sfdc_rest_api_url']+'/challenges/'+id+'/categories?fields=id,name,display_name__c')
    p cats
    cats.each do |cat|
      catnames.push(cat['Display_Name__c'])
    end
    return catnames
  end
  
  def self.get_prizes(access_token, id)
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+'/challenges/'+id+'/prizes?fields=Prize__c,Place__c&orderby=place__c')
  end
  
  def self.get_registrants(access_token, id)
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+'/participants?challengeid='+id+'&fields=Member__r.Profile_Pic__c,Member__r.Name,Member__r.Total_Wins__c')
  end
  
  def self.get_winners(access_token, id)
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+'/participants?challengeid='+id+'&fields=id,name,place__c,score__c,member__r.name,status__c,money_awarded__c,points_awarded__c,member__r.profile_pic__c,member__r.summary_bio__c&orderby=place__c')
  end
  
  def self.get_leaderboard(access_token, from_date, page_num)
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+'/leaderboard?pageNum='+page_num.to_s+'&dateFormat='+from_date.to_s)
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
    put(ENV['sfdc_rest_api_url']+'/submissions/'+submissionId+'?deleted__c=true')
  end
  
  def self.current_submissions(access_token, participantId)
    set_header_token(access_token) 
    get(ENV['sfdc_rest_api_url']+'/submissions?participantid='+participantId)
  end
  
end