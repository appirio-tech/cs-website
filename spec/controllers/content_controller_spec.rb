require 'spec_helper'

describe ContentController do
  let(:settings) { stub_model(Settings, :auth_token => "123456")}
  
  before(:each) do
    Utils.stub(:public_access_token).and_return(settings.auth_token)
  end
  
  it "should success in home action" do
    message = '{"featured_member_username" : "kerdosa"}'
    stub_request(:get, /#{ENV['SFDC_REST_API_URL']}\/webpages.*/).to_return(:body => message, :status => 200)
    stub_request(:get, /#{ENV['SFDC_REST_API_URL']}\/leaderboard.*/).to_return(:body => '[]', :status => 200)
    get :home
    response.should be_success
    response.should render_template('home')
  end
  
  it "should success in faq action" do
    message = '{"featured_member_username" : "kerdosa"}'
    stub_request(:get, /#{ENV['SFDC_REST_API_URL']}\/faq.*/).to_return(:body => message, :status => 200)
    get :faq
    response.should be_success
    response.should render_template('faq')
  end

  it "should success in about action" do
    message = '{"featured_member_username" : "kerdosa"}'
    stub_request(:get, /#{ENV['SFDC_REST_API_URL']}\/webpages.*/).to_return(:body => message, :status => 200)
    get :about
    response.should be_success
    response.should render_template('about')
  end

  it "should success in privacy action" do
    message = '{"featured_member_username" : "kerdosa"}'
    stub_request(:get, /#{ENV['SFDC_REST_API_URL']}\/webpages.*/).to_return(:body => message, :status => 200)
    get :privacy
    response.should be_success
    response.should render_template('privacy')
  end

  it "should success in tos action" do
    message = '{"featured_member_username" : "kerdosa"}'
    stub_request(:get, /#{ENV['SFDC_REST_API_URL']}\/webpages.*/).to_return(:body => message, :status => 200)
    get :tos
    response.should be_success
    response.should render_template('tos')
  end
end
