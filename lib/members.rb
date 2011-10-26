require 'cloud_spokes'
class Members < Cloudspokes

  def self.challenges(options = {:name => ""})
    request_url  = ENV['sfdc_rest_api_url'] +  "/members/" + options[:name] + "/challenges"
    get(request_url) 
  end

end

