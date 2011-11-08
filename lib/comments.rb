require 'cloud_spokes'

class Comments < Cloudspokes
  
  def self.save(access_token, username, params)
    
    options = {
      :body => {
          :username => username,
          :challenge => params[:id],
          :comment => params[:discussion][:comments],
          :replyto => params[:discussion][:reply_to]
      }
    }
    
    results = post(ENV['sfdc_rest_api_url']+'/comments', options)
  end
  
  def self.find_by_challenge(access_token, id)
    set_header_token(access_token) 
    comments = get(ENV['sfdc_rest_api_url']+'/comments/'+id)
  end

end

