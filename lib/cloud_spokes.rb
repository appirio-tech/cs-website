# This object is the main entry point for connection to SFDC and DBDC
# All sObjects inherit from him and can use generic methods like
#   object.all
#   object.find
#   object.update

require 'uri' 

class Cloudspokes 

  include HTTParty 
  format :json

  AvailableObjects = ["challenges","members","participants","faqs","webpages","categories","terms_of_service"]
  SFDC_URL         = ENV['SFDC_INSTANCE_URL']+'/services/data/v20.0/sobjects/'

  headers 'Content-Type' => 'application/json'

  def self.esc(str)
    URI.escape(str)
  end
  
  def self.set_header_token(access_token)
    headers 'Authorization' => "OAuth #{access_token}" 
  end

  def self.set_api_header_token(access_token)
    headers 'oauth_token' => "#{access_token}" 
  end  

  def self.set_api_header_key
    headers 'Authorization' => 'Token token="'+ENV['CS_API_KEY']+'"'
  end    

  # generic get with given options
  def self.get_sobjects(options)
    if AvailableObjects.include?(self.to_s.downcase)
      request_url  = ENV['SFDC_REST_API_URL'] + "/#{self.to_s.downcase}?fields=#{esc options[:select]}"
      request_url += ("&orderby=#{esc options[:order_by]}") unless options[:order_by].nil?
      request_url += ("&search=#{esc options[:where]}") unless options[:where].nil?
      request_url += ("&limit=#{esc options[:limit]}") unless options[:limit].nil?
      get(request_url)
    end
  end

  # update a given object
  def self.update(access_token, id, params)
    set_header_token(access_token)
    if AvailableObjects.include?(self.to_s.downcase)      
      request_url  = ENV['SFDC_REST_API_URL'] + '/' + self.to_s.downcase + "/" + id
      put(request_url,:query => params)
    end
  end
  

  # return a particular object
  def self.find(access_token, id)
    set_header_token(access_token)    
    if AvailableObjects.include?(self.to_s.downcase)
      request_url  = SFDC_URL + self.to_s.singularize.capitalize + "__c/" + id
      get(request_url)
    end
  end
  
  # return all records of a given sObject
  def self.all(access_token, options = {:select => "id,name", :order_by => nil, :where => nil})
    set_header_token(access_token)
    get_sobjects(:select => options[:select], :order_by => options[:order_by], :where => options[:where])
  end

  # Create generic methods for get_<sObject_name> methods
  AvailableObjects.each do |sobject|
    class_eval <<-EOS
      def self.get_#{sobject}
        request_url = ENV['SFDC_REST_API_URL'] + '/' + '#{sobject}'
        get(request_url)
      end
    EOS
  end
end

