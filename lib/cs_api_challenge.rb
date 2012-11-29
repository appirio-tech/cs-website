require 'cs_api'

module CsApi

  class Challenge < CloudSpokesApi	

	  def self.open(access_token)
	    set_api_header_token(access_token)    
	    get(ENV['CS_API_URL']+"/challenges")['response']
	  end  	  	 	  

  end

end