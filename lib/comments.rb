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
    
    results = post(ENV['SFDC_REST_API_URL']+'/comments', options)
  end
  
  def self.find_by_challenge(access_token, id)
    set_header_token(access_token) 
    comments = get(ENV['SFDC_REST_API_URL']+'/comments/'+id)
  end

end

