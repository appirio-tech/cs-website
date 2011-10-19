class Challenges 
  
  include HTTParty 
  format :json
  
  headers 'Content-Type' => 'application/json' 

  def self.get_challenges(access_token) 
    headers 'Authorization' => "OAuth #{access_token}"      
    get(ENV['sfdc_instance_url']+'/challenges')
  end 
  
end