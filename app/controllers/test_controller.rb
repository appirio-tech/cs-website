class TestController < ApplicationController
  
  require 'services'
  include HTTParty   
  
  def profile_pic
    if params["form_profile"]
      p '========== checking for profile pic upload'
      if !params["form_profile"]["Profile_Pic__c"].nil?
        p '==== it it not nil ... so posting to gae'
        options = {
          :body => {
              :image => params["form_profile"]["Profile_Pic__c"].read 
          }
        }
        results = post('http://cs-image-service.appspot.com', options)
        p "====== post results: #{results}"
      end
      p params
    end
  end
  
  def send_mail
    Resque.enqueue(WelcomeEmailSender, current_access_token, 'jefftest5')
    render :inline => "Mail sent"
  end
  
  def s3
    @files = AWS::S3::Bucket.find('cs-sandbox').objects  
    p '======= files'
    p @files
    buckets = AWS::S3::Bucket.list
    p '======= buckets'
    p buckets
  end
  
  def dump_env
    p '============ dump_env'
    @results = ENV
  end
  
  def display_users
    p '============ display_users'
    @results = User.all
  end
  
  def display_settings
    p '============ display_settings'
    @results = Settings.all
  end
  
  def auth_cloudspokes
    p '============ auth_cloudspokes'
    @results = User.authenticate('testuser9-cs','!sbx9876')
  end
  
  def auth_thirdparty
    p '============ auth_thirdparty'
    @results = current_access_token
  end
  
  def service_sfdc_username
    p '============ service_sfdc_username'
    @results = Services.sfdc_username(current_access_token, 'github', 'jeffdonthemic')
  end
  
  def service_new_member_cloudsppokes
    p '============ service_new_member_cloudsppokes'
    @results = Services.new_member(current_access_token, {:username => 'jeffdonthemic', :email => 'jeff@jeffdouglas.com', :password => 'changeme'})
  end
  
  def get_current_access_token
    p '============ current_access_token'
    @results = current_access_token
  end
  
end
