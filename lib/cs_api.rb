require 'uri' 

class CloudSpokesApi

	include HTTParty 
  format :json
  headers 'Content-Type' => 'application/json'

  def self.set_api_header_token(access_token)
    headers 'oauth_token' => "#{access_token}" 
  end  

  def self.set_api_header_key
    headers 'Authorization' => 'Token token="'+ENV['CS_API_KEY']+'"'
  end    

  def self.esc(str)
    URI.escape(str)
  end  	

end