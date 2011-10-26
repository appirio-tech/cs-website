require 'cloud_spokes'
class Password < Cloudspokes

  def self.reset(name)
    request_url  = BASE_URL +  "password/reset?username=" + name
    post(request_url,:body => {})
  end

  def self.update(name,passcode,newpassword)
    request_url  = BASE_URL +  "password/reset?username=" + name + "&passcode=" + passcode + "&newpassword=" + newpassword 
    put(request_url,:body => {}) 
  end

end
