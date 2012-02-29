require 'spec_helper'

describe QuizesController do

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'answer'" do
    it "returns http success" do
      get 'answer'
      response.should be_success
    end
  end

  describe "GET 'practice'" do
    it "returns http success" do
      get 'practice'
      response.should be_success
    end
  end

  describe "GET 'leaderboard'" do
    it "returns http success" do
      get 'leaderboard'
      response.should be_success
    end
  end

end
