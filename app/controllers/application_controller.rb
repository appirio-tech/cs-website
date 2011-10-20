class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  require 'sitesettings'
  require "auth"
  
  # fetch the access token for this user or return the public access token from the database
  def current_access_token
    if current_user.nil?
      p '======= returning the public access token'
      return SiteSettings.public_access_token
    else
      p '======= returning the user access token'
            
      # if the access token is nil or the access token hasn't been updated in an hour
      if current_user.access_token.nil? || Time.now > current_user.updated_at.getlocal + (60*60)
        
        p '======= current_user access token is nil or an hour old. fetching new access token'
        
        config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
        client = Databasedotcom::Client.new(config)
        sfdc_username = current_user.username+'@'+ENV['sfdc_username_domain']
        puts "--- logging into salesforce with #{sfdc_username} and #{current_user.password}"
        
        begin

          access_token = client.authenticate :username => sfdc_username, :password => current_user.password
          current_user.access_token = access_token
          current_user.save
          return current_user.access_token

        # seem to get this error for brand new users after they are created
        # if we get an error, just return the public_access_token. it will check again on the
        # next call to this method until it returns the access_token successfully
        rescue Exception => exc
          p '========= error getting the access_token for the user. returning public_access_token'
          p exc.message
          return SiteSettings.public_access_token
        end
        
      else
        return current_user.access_token
      end
      
    end
    
  end

end
