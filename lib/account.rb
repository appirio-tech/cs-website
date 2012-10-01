class Account < Cloudspokes

	require 'cloud_spokes'

  def self.reset_password(name)
    set_api_header_key   
    request_url  = ENV['CS_API_URL'] + "/accounts/reset_password/#{esc name}"
    get(request_url)['response']
  end

  # moved to new api
  def self.update_password(membername, passcode, newpassword)
    set_api_header_key     	
    put(ENV['CS_API_URL'] + "/accounts/update_password/#{esc membername}?passcode=#{esc passcode}&new_password=#{esc newpassword}")['response'] 
  end	

end