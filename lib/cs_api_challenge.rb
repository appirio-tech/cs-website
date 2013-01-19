require 'cs_api'

module CsApi

  class Challenge < CloudSpokesApi	

	  def self.open(access_token)
	    set_api_header_token(access_token)    
	    get(ENV['CS_API_URL']+"/challenges")['response']
	  end  	 

		def self.create(access_token, data)
			set_api_header_token(access_token)   
			options = { :body => data.to_json }  
			post(ENV['CS_API_URL'] + "/admin/challenges", options)
		end

		def self.update(access_token, challenge_id, data)
			set_api_header_token(access_token)   
			# add the challenge id to the json
			data['challenge']['detail']['challenge_id__c'] = challenge_id
			options = { :body => data.to_json }  
			put(ENV['SFDC_APEXREST_URL'] + "/admin/challenges", options)
		end  


  end

end