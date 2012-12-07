require 'cs_api'

module CsApi

  class Community < CloudSpokesApi	

	  def self.all(access_token)
	    set_api_header_token(access_token)     
	    get(ENV['CS_API_URL']+"/communities")['response']
	  end  

    def self.find(access_token, community_id)
    	set_api_header_token(access_token)
      get(ENV['CS_API_URL']+"/communities/#{community_id}")['response']
    end		  	

    def self.add_member(access_token, params)
      set_api_header_token(access_token)
      set_api_header_key   
      options = {
        :body => params.to_json
      }
      post(ENV['CS_API_URL']+"/communities/add_member", options)['response']
    end

  end

end