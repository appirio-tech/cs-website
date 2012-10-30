class NewBadgeVilleUser
  include HTTParty 
  
  @queue = :new_badgeville_user
  def self.perform(access_token, username, email)

    # create the badgeville user
    Badgeville.create_user(username, email.downcase)
    
    # sleep for 10 seconds to allow badgeville to process user
    sleep(10)
    
    #create the badgeville player
    player_id = Badgeville.create_player(username.downcase, email.downcase)
    
    unless player_id.nil?
      Badgeville.send_site_registration(player_id)
      # update sfdc with badgeville player id
      CsApi::Member.update(access_token, username, {"Badgeville_Id__c" => player_id})
    end
    
  end
  
end