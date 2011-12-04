require 'cloud_spokes'
require 'cgi'

class Password < Cloudspokes

  # sends the reset email
  def self.reset(name)
    p "===== making sfdc request to change password"
    request_url  = ENV['SFDC_REST_API_URL'] + "/password/reset?username=#{name}"
    post(request_url,:body => {})
  end

  def self.update(name, passcode, newpassword)
    request_url  = ENV['SFDC_REST_API_URL'] + "/password/reset?username=#{name}&passcode=#{passcode}&newpassword=#{newpassword}"
    put(request_url,:body => {}) 
  end

end
