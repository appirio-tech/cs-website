require 'cs_api_community'

class MarketingUpdateNewMember
  include HTTParty 
  
  @queue = :marketing_update_queue
  def self.perform(access_token, membername, marketing_hash)
    
    Rails.logger.info "[Resque]==== updating new member #{membername} with marketing data: #{marketing_hash}"
    
    update_hash = { 'Campaign_Source__c' =>  marketing_hash['campaign_source'], 
      'Campaign_Medium__c' =>  marketing_hash['campaign_medium'], 
      'Campaign_Name__c' =>  marketing_hash['campaign_name'] }
    
    results = CsApi::Member.update(access_token, membername, update_hash)

    # see if there is a community with a matching campaign name
    community = SfdcConnection.admin_dbdc_client.query("select id, name, community_id__c from community__c where Marketing_Campaign__c = '#{marketing_hash['campaign_name']}'")
    # if we found a matching community, add them to it
    unless community.empty?
    	CsApi::Community.add_member(access_token, {:membername => membername, :community_id => community.first['Community_Id__c']})
    end

  end
  
end