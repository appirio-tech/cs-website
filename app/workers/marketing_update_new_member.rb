class WelcomeEmailSender
  include HTTParty 
  
  @queue = :marketing_update_queue
  def self.perform(access_token, username, marketing_hash)
    
    update_hash = { 'Campaign_Source__c' =>  marketing_hash[:campaign_source], 
      'Campaign_Medium__c' =>  marketing_hash[:campaign_medium], 
      'Campaign_Name__c' =>  marketing_hash[:campaign_name] }
    
    Members.update(current_access_token, username, update_hash)
        
  end
  
end