require 'cloud_spokes'
class Members < Cloudspokes

  def self.challenges(access_token, options = {:name => ""})
    set_header_token(access_token)    
    request_url  = ENV['sfdc_rest_api_url'] +  "/members/#{esc options[:name]}/challenges"
    get(request_url) 
  end
  
  # return a particular object
  def self.find_by_username(access_token, username, fields)
    set_header_token(access_token)    
    get(ENV['sfdc_rest_api_url']+"/members/#{esc username}?fields=#{esc fields.gsub(' ','').downcase}")
  end
  
  def self.upload_profile_pic(pic)
    
    options = {
      :body => {
          :image => pic
      }
    }
    results = post('http://cs-image-service.appspot.com/upload', options)
    p "====== post results: #{results}"
    
  end

end

