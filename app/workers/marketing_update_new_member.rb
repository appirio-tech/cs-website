class MarketingUpdateNewMember
  include HTTParty 
  
  @queue = :marketing_update_queue
  def self.perform(access_token, username, marketing_hash)
    
    Rails.logger.info "[Resque]==== updating new user #{username} with marketing data: #{marketing_hash}"
    
    update_hash = { 'Campaign_Source__c' =>  marketing_hash['campaign_source'], 
      'Campaign_Medium__c' =>  marketing_hash['campaign_medium'], 
      'Campaign_Name__c' =>  marketing_hash['campaign_name'] }
    
    results = Members.update(access_token, username, update_hash)
        
  end
  
end