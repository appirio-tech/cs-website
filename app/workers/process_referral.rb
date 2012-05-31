require 'utils'

class ProcessReferral
  
  @queue = :process_referral
  def self.perform(referral_id_or_username, converted_member_name)
    
    # materialize the objects
    Utils.shared_dbdc_client.materialize("Member__c")
    Utils.shared_dbdc_client.materialize("Referral__c")
    
    # try to find a member by the referral_id_or_username
    referred_by_member = Member__c.find_by_name(referral_id_or_username)
    converted_member = Member__c.find_by_Name(converted_member_name)
    
    # update an existing referral
    if referred_by_member.nil? 
      
      referral = Referral__c.find(referral_id_or_username)
      referral.update_attributes "Converted_To_Member__c" => converted_member.Id,
        "Converted__c" => true
      referral.save

    # create a NEW referral record for a member
    else 
      
      referral = Referral__c.new
      referral.OwnerId = Utils.shared_dbdc_client.user_id
      referral.Converted_To_Member__c = converted_member.Id
      referral.Referred_By_Member__c = referred_by_member.Id
      referral.Converted__c = true
      referral.Include_in_Member_Count__c = false
      referral.Source__c = 'Member'
      referral.save
      
    end
  
  end
  
end