require 'cloud_spokes'
class Password < Cloudspokes

  # sends the reset email
  def self.reset(name)

    request_url  = ENV['sfdc_rest_api_url'] + "/password/reset?username=#{esc name}"
    post(request_url,:body => {})
  end

  def self.update(name, passcode, newpassword)
    request_url  = ENV['sfdc_rest_api_url'] + "/password/reset?username=#{esc name}&passcode=#{esc passcode}&newpassword=#{esc newpassword}"
    put(request_url,:body => {}) 
  end

end
