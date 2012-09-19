require 'spec_helper'

describe ContentController do
  describe "content#home" do
    let(:web_pages) {  JSON.parse File.read(Rails.root.join("spec/data/web_pages.json")) }
    let(:leaders) { JSON.parse File.read(Rails.root.join("spec/data/leaders.json")) }
    before(:each) do
      controller.stub(:current_access_token).and_return("access_token")

      Webpages.stub(:all).and_return(web_pages)
      Challenges.stub(:get_leaderboard).and_return(leaders)
    end

    it "returns http success" do
      get 'home'
      response.should be_success
    end

    it "assigns web page variables" do
      variables = %w(featured_member_username, featured_member_pic, featured_member_money, featured_member_active, featured_member_wins, members, challenes_open, chalenges_won, money_up_for_grabs, money_pending, entries_submitted, featured_challenge_id, featured_challenge_name,       featured_challenge_prize, featured_challenge_details)

      get 'home'
      variables.each do |var|
        assigns(var).should == web_pages[var]
      end
    end

    it "assigns leaders" do
      get 'home'

      assigns(:leaders).should == leaders
    end
  end
end
