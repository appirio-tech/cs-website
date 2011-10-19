class TestController < ApplicationController
  
  require 'services'
  
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
    @results = Services.sfdc_username('github', 'jeffdonthemic')
  end
  
  def service_new_member_cloudsppokes
    p '============ service_new_member_cloudsppokes'
    @results = Services.new_member({:username => 'jeffdonthemic', :email => 'jeff@jeffdouglas.com', :password => 'changeme'})
  end
  
  def get_current_access_token
    p '============ current_access_token'
    @results = current_access_token
  end
  
end
