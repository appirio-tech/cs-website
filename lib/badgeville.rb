require 'cgi'

class Badgeville
  
  def self.create_user(username, email)
        
    options = {
      :body => {
          'user[name]' => username,
          'user[email]' => email
      }
    }
    
    results = HTTParty::post(ENV['BADGEVILLE_API_URL']+'/api/berlin/'+ENV['BADGEVILLE_API_KEY']+'/users.json', options)
    Rails.logger.info "[Badgeville]==== created user #{username} with response from badgeville: #{results}"
    
  end
  
  def self.create_player(username, email)
    
    options = {
      :body => {
          'email' => email,
          'site' => 'www.cloudspokes.com',
          'player[display_name]' => username,
          'player[nickname]' => username,
          'player[email_notifications]' => false
      }
    }
    
    results = HTTParty::post(ENV['BADGEVILLE_API_URL']+'/api/berlin/'+ENV['BADGEVILLE_API_KEY']+'/players.json', options)
    Rails.logger.info "[Badgeville]==== created player #{username} with response from badgeville: #{results}"

    return results['id']
    
  end

  def self.update_player(member)
        
    options = {
      :body => {
          'player[name]' => member['name'],
          'player[display_name]' => member['name'],
          'player[nickname]' => member['name'],
          'player[first_name]' => member['first_name'],
          'player[last_name]' => member['last_name'],
          'player[picture_url]' => member['profile_pic'],
          'player[custom_picture_url]' => member['profile_pic']
          
      }
    }
    results = HTTParty::put("#{ENV['BADGEVILLE_API_URL']}/api/berlin/#{ENV['BADGEVILLE_API_KEY']}/players/#{member['badgeville_id']}.json", options)
    Rails.logger.info "[Badgeville]==== updated #{member['name']} with player_id #{member['badgeville_id']} in Badgeveille with response: #{results}"
  end

  def self.update_user(badgeville_user_id, username, email)
        
    options = {
      :body => {
          'user[name]' => username,
          'user[email]' => email.downcase
          
      }
    }
    results = HTTParty::put("#{ENV['BADGEVILLE_API_URL']}/api/berlin/#{ENV['BADGEVILLE_API_KEY']}/users/#{badgeville_user_id}.json", options)
    Rails.logger.info "[Badgeville]==== updated #{username} with user_id #{badgeville_user_id} in Badgeveille with response: #{results}"
  end


  def self.send_site_registration(player_id)

    options = {
      :body => {
        'activity[verb]' => "registered_on_site",
        'player_id' => player_id
      }
    }

    HTTParty::post(ENV['BADGEVILLE_API_URL']+'/api/berlin/'+ENV['BADGEVILLE_API_KEY']+'/activities.json', options)

  end 

  def self.get_user_by_email(email)    
    results = HTTParty::get(ENV['BADGEVILLE_API_URL']+'/api/berlin/'+ENV['BADGEVILLE_API_KEY']+'/users/'+email.downcase+'.json')
    Rails.logger.info "[Badgeville]==== get user by email #{email} with response from badgeville: #{results}"
    return results
  end

  def self.get_player_by_email(email)    
    results = HTTParty::get(ENV['BADGEVILLE_API_URL']+'/api/berlin/'+ENV['BADGEVILLE_API_KEY']+'/players/info.json?site=www.cloudspokes.com&email='+email)
    Rails.logger.info "[Badgeville]==== get player by email #{email} with response from badgeville: #{results}"
    return results
  end  

  def self.get_player_by_id(player_id)    
    results = HTTParty::get(ENV['BADGEVILLE_API_URL']+'/api/berlin/'+ENV['BADGEVILLE_API_KEY']+'/players/'+player_id+'.json')
    Rails.logger.info "[Badgeville]==== get player by player_id #{player_id} with response from badgeville: #{results}"
    return results
  end         

end