require 'spec_helper'

describe ChallengesController do

  describe "with invalid challenge" do
    it "redirects to challenges" do
      Challenges.stub!(:find_by_id).and_return([])
      get :show, :id => 1
      response.should redirect_to('/challenges')
    end
  end

  describe "#register" do
    it "sets participation status" do
      challenge_detail = mock('challenge_detail')
      challenge_detail.should_receive(:[]).with('Start_Date__c').and_return(1.day.from_now.to_s)
      controller.stub!(:current_challenge).and_return(challenge_detail)

      #Challenges.should_receive(:set_participation_status).once
      post :register, :id => 1
      response.should be_redirect
    end

    it "doesn't set participation status when terms are required" do
      challenge_detail = stub('challenge_detail')
      challenge_detail.should_receive(:[]).with('Start_Date__c').and_return(1.day.from_now.to_s)
      controller.stub!(:current_challenge).and_return(challenge_detail)

      #Challenges.should_receive(:set_participation_status).once
      post :register, :id => 1
      response.should be_redirect
    end
  end
end
