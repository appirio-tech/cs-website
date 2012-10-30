class MarketingUpdateNewMember
  include HTTParty 
  
  @queue = :marketing_update_queue
  def self.perform(access_token, membername, marketing_hash)
    
    Rails.logger.info "[Resque]==== updating new member #{membername} with marketing data: #{marketing_hash}"
    
    update_hash = { 'Campaign_Source__c' =>  marketing_hash['campaign_source'], 
      'Campaign_Medium__c' =>  marketing_hash['campaign_medium'], 
      'Campaign_Name__c' =>  marketing_hash['campaign_name'] }
    
    results = CsApi::Member.update(access_token, membername, update_hash)
        
  end
  
end