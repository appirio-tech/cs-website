class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  require 'sitesettings'
  require "auth"
  
  # initiliaze default fields for CloudSpokes API request
  DEFAULT_MEMBER_FIELDS         = "id,name,company__c,school__c,years_of_experience__c,work_status__c,shirt_size__c,age_range__c,gender__c,email__c,last_name__c,first_name__c,address_line1__c,address_line2__c,city__c,zip__c,state__c,phone_mobile__c,time_zone__c,profile_pic__c,country__c,summary_bio__c,quote__c,challenges_entered__c,total_money__c,website__c,twitter__c,linkedin__c,icq__c,jabber__c,github__c,facebook__c,digg__c,myspace__c,challenges_submitted__c,total_wins__c,total_points__c,total_1st_place__c,total_2nd_place__c,total_3st_place__c"
  DEFAULT_RECOMMENDATION_FIELDS = "recommendation_from__r.name,recommendation_from__r.profile_pic__c,recommendation__c,createddate"
  DEFAULT_CHALLENGE_FIELDS      = "id,name,createddate,description__c"  
    
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
