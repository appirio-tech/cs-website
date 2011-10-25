require 'members'

class AccountController < ApplicationController
  before_filter :require_login
  
  def index
    @member = Members.get_member(current_access_token,current_user.username,'id,first_name__c,last_name__c,email__c,address_line1__c,address_line2__c,city__c,state__c,zip__c,phone_mobile__c')
    puts @member
  end
  
  def save
    @results = Members.save_member(current_access_token,current_user.username,params['data'])   
    if @results[:success].eql?('false')
      flash[:error] = @results[:message]
      redirect_to(:back)
    else
      redirect_to 'account_url
    end
         
  end
  
  def details
    @member = Members.get_member(current_access_token,current_user.username,
      'id,name,first_name__c,last_name__c,email__c,address_line1__c,address_line2__c,city__c,state__c,zip__c,phone_mobile__c')
  end
  
  def schoolwork
    @member = Members.get_member(current_access_token,current_user.username,
      'id,company__c,school__c,years_of_experience__c,work_status__c,shirt_size__c,age_range__c,gender__c')
  end
  
  private
 
    def require_login
      unless logged_in?
        redirect_to login_url, :notice => 'You must be logged in to access this section'
      end
    end
 
    def logged_in?
      !!current_user
    end

end
