require 'spec_helper'

describe MembersController do
  let (:user) { stub_model(User, :id => 1, :username => 'mess', :password => "mess01")}
  let(:settings) { stub_model(Settings, :auth_token => "123456")}
      
  describe "index, search" do
    before(:each) do
      Utils.stub(:public_access_token).and_return(settings.auth_token)
      
      members_all = File.read(File.join(File.dirname(__FILE__), '..', "fixtures/members.json"))
      stub_request(:get, /#{ENV['SFDC_REST_API_URL']}\/members.*/).to_return(:body => members_all, :status => 200)
      stub_request(:get, /#{ENV['SFDC_REST_API_URL']}\/leaderboard.*/).to_return(:body => '[]', :status => 200)
    end
    
    it "should be successful with default period" do
      get :index
      response.should be_success
      response.should render_template('index')
    end
    
    it "should be successful with year" do
      get :index, :period => 'year'
      response.should be_success
      response.should render_template('index')
    end
    
    it "should be successful with all" do
      get :index, :period => 'all'
      response.should be_success
      response.should render_template('index')
    end

    it "should be successful in search action" do
      get :search
      response.should be_success
      response.should render_template('index')
    end
  end
  
  describe "show, past_challenges, recommend, recommend_new" do
    before(:each) do
      @username = 'mess'
      Utils.stub(:public_access_token).and_return(settings.auth_token)
      member_mess = File.read(File.join(File.dirname(__FILE__), '..', "fixtures/member_mess.json"))
      stub_request(:get, /#{ENV['SFDC_REST_API_URL']}\/members\/#{@username}?.*/).to_return(:body => member_mess, :status => 200)
      stub_request(:any, /#{ENV['SFDC_REST_API_URL']}\/recommendations.*/).to_return(:body => '[]', :status => 200)
      challenges = File.read(File.join(File.dirname(__FILE__), '..', "fixtures/challenges.json"))
      stub_request(:get, /#{ENV['SFDC_REST_API_URL']}\/members\/.*\/challenges/).to_return(:body => challenges, :status => 200)
    end
    
    it "should be successful in show" do
      get :show, :id => @username
      response.should be_success
      response.should render_template('show')
    end

    it "should be successful in past_challenges" do
      get :past_challenges, :id => @username
      response.should be_success
      response.should render_template('past_challenges')
    end

    it "should be fail in recommend without login" do
      get :recommend, :id => @username
      # response.should be_fail
      response.should redirect_to(login_required_url)
    end

    it "should be success in recommend with login" do
      controller.current_user = user
      get :recommend, :id => @username
      response.should be_success
      response.should render_template('recommend')
    end

    it "should be success in recommend_new" do
      controller.current_user = user
      get :recommend_new, :id => @username, :recommendation => {:comments => 'this is a comment'}
      response.should redirect_to(member_path(@username))
    end
  end
end
