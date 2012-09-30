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

  def self.recommend(access_token, membername_for, membername_from, text)
    set_api_header_token(access_token) 
    set_api_header_key   
    
    options = {
      :body => {
          :recommendation_for => membername_for,
          :recommendation_from_username => membername_from,
          :recommendation_text => text
      }.to_json
    }
    post(ENV['CS_API_URL']+"/members/#{esc membername_for}/recommendations/create", options)
  end

  def self.recommendations(access_token, membername)
    set_api_header_token(access_token)    
    get(ENV['CS_API_URL']+"/members/#{esc membername}/recommendations")['response']
  end
  
  def self.upload_profile_pic(url, pic)
    
    options = {
      :body => {
          :image => pic
      }
    }
    results = post(url, options)
    p "====== posting image to: #{url}"
    p "====== post results: #{results}"
    
  end

end

