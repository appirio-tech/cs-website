require 'spec_helper'

describe HackathonsController do

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'results'" do
    it "returns http success" do
      get 'results'
      response.should be_success
    end
  end

  describe "GET 'page'" do
    it "returns http success" do
      get 'page'
      response.should be_success
    end
  end

end
