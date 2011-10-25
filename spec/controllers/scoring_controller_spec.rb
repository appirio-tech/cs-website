require 'spec_helper'

describe ScoringController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'outstanding'" do
    it "should be successful" do
      get 'outstanding'
      response.should be_success
    end
  end

  describe "GET 'scorecard'" do
    it "should be successful" do
      get 'scorecard'
      response.should be_success
    end
  end

  describe "GET 'results'" do
    it "should be successful" do
      get 'results'
      response.should be_success
    end
  end

end
