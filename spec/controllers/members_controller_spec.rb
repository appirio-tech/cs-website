require 'spec_helper'

describe MembersController do
  it 'requires login on #recommend' do
    controller.stub!(:logged_in?).and_return(false)
    post :recommend, :id => 1
    response.should redirect_to(login_required_url)
  end

  it 'requires login on #recommend_new' do
    controller.stub!(:logged_in?).and_return(false)
    post :recommend_new, :id => 1
    response.should redirect_to(login_required_url)
  end

  context "when logged in" do
    it "should display leaderboard" do
      controller.stub!(:logged_in).and_return(true)
      get :index
      response.should be_success
    end
  end
end
