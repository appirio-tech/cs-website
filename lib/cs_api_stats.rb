require 'cs_api'

module CsApi

	class Stats < CloudSpokesApi

	  def self.public(access_token)
	    set_api_header_token(access_token)    
	    get(ENV['CS_API_URL']+"/stats")['response']
	  end  	  

	end

end