require 'spec_helper'

describe ChallengeAdminController do

  describe "GET 'preview'" do
    it "returns http success" do
      get 'preview'
      response.should be_success
    end
  end

end
