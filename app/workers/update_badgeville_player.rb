class UpdateBadgeVillePlayer
  include HTTParty 
  
  @queue = :update_badgeville_player
  def self.perform(access_token, membername, members_fields)
    Badgeville.update_player(CsApi::Member.find_by_membername(access_token, membername, members_fields))
  end
  
end