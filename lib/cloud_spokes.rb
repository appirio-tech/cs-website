# This object is the main entry point for connection to SFDC and DBDC
# All sObjects inherit from him and can use generic methods like
#   object.all
#   object.find
#   object.update

class Cloudspokes 

  include HTTParty 
  format :json

  AvailableObjects = ["challenges","members","recommendations","participants"]
  SFDC_URL         = ENV['sfdc_instance_url']+'/services/data/v20.0/sobjects/'

  headers 'Content-Type' => 'application/json' 
  headers 'Authorization' => "OAuth #{ENV['access_token']}"

  # generic get with given options
  def self.get_sobjects(options)
    if AvailableObjects.include?(self.to_s.downcase)
      request_url  = ENV['sfdc_rest_api_url'] + '/' + self.to_s.downcase + "?fields=" + options[:select]
      request_url += ("&orderby=" + options[:order_by]) unless options[:order_by].nil?
      request_url += ("&search=" + options[:where]) unless options[:where].nil?
      request_url += ("&limit=" + options[:limit]) unless options[:limit].nil?
      get(request_url)
    end
  end

  # update a given object
  def self.update(id,params)
    if AvailableObjects.include?(self.to_s.downcase)
      request_url  = ENV['sfdc_rest_api_url'] + '/' + self.to_s.downcase + "/" + id

      put(request_url,:query => params)
    end
  end
  

  # return a particular object
  def self.find(id)
    if AvailableObjects.include?(self.to_s.downcase)
      request_url  = SFDC_URL + self.to_s.singularize.capitalize + "__c/" + id

      get(request_url)
    end
  end
  
  # return all records of a given sObject
  def self.all(options = {:select => "id,name", :order_by => nil, :where => nil})
    p '======= outputting mysettings'
    p Application::current_access_token
    get_sobjects(:select => options[:select], :order_by => options[:order_by], :where => options[:where])
  end

  # Create generic methods for get_<sObject_name> methods
  AvailableObjects.each do |sobject|
    class_eval <<-EOS
      def self.get_#{sobject}
        request_url = ENV['sfdc_rest_api_url'] + '/' + '#{sobject}'
        get(request_url)
      end
    EOS
  end
end

