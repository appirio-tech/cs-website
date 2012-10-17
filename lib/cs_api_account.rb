require 'cs_api'

module CsApi

  class Account < CloudSpokesApi

    def self.create(admin_access_token, params)
    	set_api_header_token(admin_access_token)
      set_api_header_key   
  		options = {
  		  :body => params.to_json
  		}
      post(ENV['CS_API_URL'] + "/accounts/create", options)['response']
    end		

    #used for cloudspokes and third party
    def self.find_by_service(service, service_username)
      set_api_header_key   
      get(ENV['CS_API_URL'] + "/accounts/find_by_service?service=#{esc service}&service_username=#{esc service_username}")['response']
    end	

    def self.reset_password(membername)
      set_api_header_key   
      request_url  = ENV['CS_API_URL'] + "/accounts/reset_password/#{esc membername}"
      get(request_url)['response']
    end

    def self.update_password(membername, passcode, newpassword)
      set_api_header_key     	
      put(ENV['CS_API_URL'] + "/accounts/update_password/#{esc membername}?passcode=#{esc passcode}&new_password=#{esc newpassword}")['response'] 
    end		

  	def self.authenticate(membername, password)
      set_api_header_key   
  		options = {
  		  :body => {
  		      :membername => membername,
  		      :password => password
  		  }.to_json
  		}
      results = post(ENV['CS_API_URL'] + '/accounts/authenticate', options)['response']
      puts "[INFO][CsApiAccount] SFDC Authentication results for #{membername}: #{results['message']}"		
      results
  	end

  	def self.activate(membername)
      set_api_header_key  
      get(ENV['CS_API_URL'] + "/accounts/activate/#{membername}")['response'] 
  	end	

  end

end