require 'cloud_spokes'
class Members < Cloudspokes
  
  # return a particular object
  def self.find_by_username(access_token, username, fields)
    set_header_token(access_token)    
    get(ENV['SFDC_REST_API_URL']+"/members/#{esc username}?fields=#{esc fields.gsub(' ','').downcase}")
  end

end