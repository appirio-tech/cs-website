require 'cloud_spokes'
require 'cgi'

class Password < Cloudspokes

  # sends the reset email
  def self.reset(name)
    request_url  = ENV['SFDC_REST_API_URL'] + "/password/reset?username=#{name}"
    post(request_url,:body => {})
  end

  def self.update(name, passcode, newpassword)
    request_url  = ENV['SFDC_REST_API_URL'] + "/password/reset?username=#{name}&passcode=#{passcode}&newpassword=#{CGI.escape(newpassword)}"
    put(request_url,:body => {}) 
  end

end