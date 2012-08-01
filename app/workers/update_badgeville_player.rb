class UpdateBadgeVillePlayer
  include HTTParty 
  
  @queue = :update_badgeville_player
  def self.perform(access_token, membername, members_fields)
    Badgeville.update_player(Members.find_by_username(access_token, membername, members_fields)[0])
  end
  
end