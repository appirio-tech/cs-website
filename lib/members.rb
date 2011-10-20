class Members 
  
  include HTTParty 
  format :json
  
  headers 'Content-Type' => 'application/json' 

  def self.get_member(access_token, username, fields) 
    set_header_token(access_token) 
    get(ENV['sfdc_instance_url']+'/members/'+username+'?fields='+fields.gsub(' ','').downcase)
  end 
  
  # updates the member in sfdc with parameters passed. skips any invalid params.
  def self.save_member(access_token, username, params) 
    set_header_token(access_token) 
    options = { :query => params }
    response = put(ENV['sfdc_instance_url']+'/members/'+username, options)
    return {:success => response['Success'], :message => response['Message']}
  end
  
  def self.set_header_token(access_token)
    headers 'Authorization' => "OAuth #{access_token}" 
  end
  
end