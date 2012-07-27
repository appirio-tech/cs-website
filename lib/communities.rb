require 'cloud_spokes'
class Communities < Cloudspokes

  def self.find_by_name(access_token, name) 
    set_header_token(access_token)
    results = get(ENV['SFDC_REST_API_URL']+"/communities/#{name}")
  end

end