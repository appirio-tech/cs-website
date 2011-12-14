require 'spec_helper'

describe AccountsController do
  let (:user) { stub_model(User, :id => 1, :username => 'mess', :password => "mess01")}
  let(:settings) { stub_model(Settings, :auth_token => "123456")}
  
  before(:each) do
    Utils.stub(:public_access_token).and_return(settings.auth_token)
    controller.current_user = user
  end
  
  describe "GET 'index'" do
    it "should be successful" do
      member_mess = File.read(File.join(File.dirname(__FILE__), '..', "fixtures/member_mess.json"))
      stub_request(:get, /#{ENV['SFDC_REST_API_URL']}\/members\/#{user.username}?.*/).to_return(:body => member_mess, :status => 200)
      get 'index'
      response.should redirect_to(account_challenges_path)
    end
  end

end
