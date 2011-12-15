require 'spec_helper'

describe AccountsController do

  describe "GET 'index'" do
    it "should redirect to challenges" do
      controller.stub!(:require_login).and_return(true)
      controller.stub!(:get_account).and_return(true)
      get 'index'
      response.should redirect_to '/account/challenges'
    end
  end


end
