require 'cloud_spokes'
class Recommendations < Cloudspokes
  
  def self.save(access_token, username_for, username_from, text)
    
    options = {
      :body => {
          :recommendation_for_username => username_for,
          :recommendation_from_username => username_from,
          :recommendation_text => text
      }
    }
    
    post(ENV['sfdc_rest_api_url']+'/recommendations', options)
  end

end

