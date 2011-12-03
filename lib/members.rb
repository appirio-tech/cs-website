require 'cloud_spokes'
class Members < Cloudspokes

  def self.challenges(access_token, options = {:name => ""})
    set_header_token(access_token)    
    request_url  = ENV['SFDC_REST_API_URL'] +  "/members/#{esc options[:name]}/challenges"
    get(request_url) 
  end
  
  # return a particular object
  def self.find_by_username(access_token, username, fields)
    set_header_token(access_token)    
    get(ENV['SFDC_REST_API_URL']+"/members/#{esc username}?fields=#{esc fields.gsub(' ','').downcase}")
  end
  
  def self.upload_profile_pic(pic)
    
    options = {
      :body => {
          :image => pic
      }
    }
    results = post('http://csimage123.appspot.com/upload', options)
    p "====== post results: #{results}"
    
  end

end

