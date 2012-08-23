class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  require 'sfdc_connection'
  
  # initiliaze default fields for CloudSpokes API request
  DEFAULT_MEMBER_FIELDS         = "id,name,company__c,school__c,years_of_experience__c,work_status__c,shirt_size__c,age_range__c,gender__c,email__c,last_name__c,first_name__c,address_line1__c,address_line2__c,city__c,zip__c,state__c,phone_mobile__c,time_zone__c,profile_pic__c,country__c,summary_bio__c,quote__c,challenges_entered__c,total_public_money__c,website__c,twitter__c,linkedin__c,icq__c,jabber__c,github__c,facebook__c,digg__c,myspace__c,total_wins__c,total_points__c,total_1st_place__c,total_2nd_place__c,total_3st_place__c,Login_Managed_By__c,Paperwork_Received__c,Paperwork_Sent__c,Paperwork_Year__c,Paypal_Payment_Address__c,Preferred_Payment__c,valid_submissions__c,badgeville_id__c"
  PUBLIC_MEMBER_FIELDS          = "id,name,school__c,years_of_experience__c,gender__c,time_zone__c,profile_pic__c,country__c,summary_bio__c,quote__c,challenges_entered__c,total_public_money__c,website__c,twitter__c,linkedin__c,icq__c,jabber__c,github__c,facebook__c,digg__c,myspace__c,total_wins__c,total_points__c,total_1st_place__c,total_2nd_place__c,total_3st_place__c,valid_submissions__c,badgeville_id__c"
  MEMBER_SEARCH_FIELDS          = "id,name,profile_pic__c,summary_bio__c,challenges_entered__c,active_challenges__c,total_wins__c,total_1st_place__c,total_2nd_place__c,total_3st_place__c,total_public_money__c"
  DEFAULT_RECOMMENDATION_FIELDS = "recommendation_from__r.name,recommendation_from__r.profile_pic__c,recommendation__c,createddate"
  DEFAULT_CHALLENGE_FIELDS      = "id,name,createddate,description__c" 
    
  def notifications 
    notifications = Rails.cache.fetch('notifications', :expires_in => 30.minute) do
      SfdcConnection.admin_dbdc_client.query("select id, name, url__c from Site_Notification__c")
    end
    render :json => notifications
  end

  # fetch the access token for this user or return the public access token from the database
  def current_access_token
    if current_user.nil?
      return SfdcConnection.public_access_token
    else
      return SfdcConnection.member_access_token current_user
    end
  end

  def redirect_to_http
    redirect_to url_for params.merge({:protocol => 'http://'}) unless !request.ssl?
  end

  def require_login
    unless logged_in?
      flash[:error] = 'You must be logged in to access this page.'
      redirect_to login_required_url
    end
  end

  def appirio_user?
    if logged_in?
      begin
        current_user.email.include?('@appirio.com') ? true : false
      rescue Exception => exc
        logger.error "[ApplicationController]==== error determining if appirio user. current_user is #{current_user.inspect}. Error is #{exc.message}"
        return false
      end   
    else
      false
    end
  end

  def logged_in?
    !!current_user
  end  

end
