require 'cs_api'

module CsApi

  class Judging < CloudSpokesApi	

	  def self.queue(access_token)
	    set_api_header_token(access_token)    
      set_api_header_key   	    
	    get(ENV['CS_API_URL']+"/judging")['response']
	  end  

    def self.add(access_token, params)
    	set_api_header_token(access_token)
      set_api_header_key   
  		options = {
  		  :body => params.to_json
  		}
      post(ENV['CS_API_URL']+"/judging/add", options)['response']
    end		  	 	  

  end

end