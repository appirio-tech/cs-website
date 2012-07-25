class Badgeville
  
  include HTTParty 
  
  def self.create_user(username, email)
        
    options = {
      :body => {
          'user[name]' => username,
          'user[email]' => email
      }
    }
    
    results = post(ENV['BADGEVILLE_API_URL']+'/api/berlin/'+ENV['BADGEVILLE_API_KEY']+'/users.json', options)
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
    
    results = post(ENV['BADGEVILLE_API_URL']+'/api/berlin/'+ENV['BADGEVILLE_API_KEY']+'/players.json', options)
    Rails.logger.info "[Badgeville]==== created player #{username} with response from badgeville: #{results}"

    return results['id']
    
  end

  def self.send_site_registration(player_id)

    options = {
      :body => {
        'activity[verb]' => "registered_on_site",
        'player_id' => player_id
      }
    }

    post(ENV['BADGEVILLE_API_URL']+'/api/berlin/'+ENV['BADGEVILLE_API_KEY']+'/activities.json', options)

  end  

  def self.get_user_by_email(email)    
    results = get(ENV['BADGEVILLE_API_URL']+'/api/berlin/'+ENV['BADGEVILLE_API_KEY']+'/users/'+email+'.json')
    Rails.logger.info "[Badgeville]==== get user by email #{email} with response from badgeville: #{results}"
    return results
  end

  def self.get_player_by_email(email)    
    results = get(ENV['BADGEVILLE_API_URL']+'/api/berlin/'+ENV['BADGEVILLE_API_KEY']+'/players/info.json?site=www.cloudspokes.com&email='+email)
    Rails.logger.info "[Badgeville]==== get player by email #{email} with response from badgeville: #{results}"
    return results
  end  

end