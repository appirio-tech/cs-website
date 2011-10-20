class Challenges 
  
  include HTTParty 
  format :json
  
  headers 'Content-Type' => 'application/json' 

  def self.get_challenges(access_token) 
    set_header_token(access_token) 
    get(ENV['sfdc_instance_url']+'/challenges')
  end 
  
  def self.set_header_token(access_token)
    headers 'Authorization' => "OAuth #{access_token}" 
  end
  
end