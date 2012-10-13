require 'cs_api'

module CsApi

  class Member < CloudSpokesApi

	  def self.update(access_token, membername, params)
	    set_api_header_token(access_token)   
	    set_api_header_key   
	    put(ENV['CS_API_URL']+"/members/#{esc membername}/update", :query => params)['response']
	  end

	  def self.search(access_token, keyword, fields)
	    set_api_header_token(access_token)    
	    get(ENV['CS_API_URL']+"/members/search?keyword=#{keyword}&fields=#{esc fields}")['response']
	  end  	   	

	  def self.all(access_token, fields, order_by)
	    set_api_header_token(access_token)    
	    get(ENV['CS_API_URL']+"/members?fields=#{esc fields}&order_by=#{esc order_by}")['response']
	  end  	  	

	  def self.find_by_membername(access_token, membername, fields)
	    set_api_header_token(access_token)    
	    get(ENV['CS_API_URL']+"/members/#{esc membername}?fields=#{esc fields.gsub(' ','').downcase}")['response']
	  end  	

	  def self.challenges(access_token, membername)
	    set_api_header_token(access_token)     
	    get(ENV['CS_API_URL']+"/members/#{esc membername}/challenges")['response'] 
	  end  	 	

	  def self.recommend(access_token, membername_for, membername_from, text)
	    set_api_header_token(access_token) 
	    set_api_header_key   
	    
	    options = {
	      :body => {
	          :recommendation_for => membername_for,
	          :recommendation_from_username => membername_from,
	          :recommendation_text => text
	      }.to_json
	    }
	    post(ENV['CS_API_URL']+"/members/#{esc membername_for}/recommendations/create", options)
	  end

	  def self.recommendations(access_token, membername)
	    set_api_header_token(access_token)    
	    get(ENV['CS_API_URL']+"/members/#{esc membername}/recommendations")['response']
	  end
	  
	  def self.payments(access_token, membername)
	    set_api_header_token(access_token) 
	    set_api_header_key   
	    get(ENV['CS_API_URL']+"/members/#{esc membername}/payments")['response']
	  end    	

  end

end