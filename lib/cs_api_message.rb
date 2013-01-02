require 'cs_api'

module CsApi

  class Message < CloudSpokesApi	

	  def self.inbox(access_token, membername)
	    set_api_header_token(access_token)
			set_api_header_key        
	    get(ENV['CS_API_URL']+"/messages/inbox/#{membername}")['response']
	  end 

	  def self.to(access_token, membername)
	    set_api_header_token(access_token)     
			set_api_header_key        
	    get(ENV['CS_API_URL']+"/messages/to/#{membername}")['response']
	  end

	  def self.from(access_token, membername)
	    set_api_header_token(access_token)     
			set_api_header_key        
	    get(ENV['CS_API_URL']+"/messages/from/#{membername}")['response']
	  end	  	  

    def self.find(access_token, id)
    	set_api_header_token(access_token)
			set_api_header_key            	
      get(ENV['CS_API_URL']+"/messages/#{id}")['response']
    end		  	 

	  def self.reply(access_token, id, params)
	    set_api_header_token(access_token)
			set_api_header_key        	    
	    options = { :body => { 'data' => params }.to_json }
	    post(ENV['CS_API_URL']+'/messages/'+id+'/reply', options)['response']
	  end 

	  def self.create(access_token, params)
	    set_api_header_token(access_token)
			set_api_header_key        	    
	    options = { :body => { 'data' => params }.to_json }
	    post(ENV['CS_API_URL']+'/messages', options)['response']
	  end 	

	  def self.update(access_token, id, params)
	    set_api_header_token(access_token)
			set_api_header_key        	    
	    put(ENV['CS_API_URL']+'/messages/'+id, :query => { 'data' => params })['response']
	  end   

  end

end