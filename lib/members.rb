require 'cloud_spokes'
class Members < Cloudspokes

  def self.challenges(access_token, options = {:name => ""})
    set_header_token(access_token)    
    request_url  = ENV['sfdc_rest_api_url'] +  "/members/" + options[:name] + "/challenges"
    get(request_url) 
  end
  
  # return a particular object
  def self.find_by_username(access_token, username, fields)
    set_header_token(access_token)    
    get(ENV['sfdc_rest_api_url']+'/members/'+username+'?fields='+fields.gsub(' ','').downcase)
  end

end

