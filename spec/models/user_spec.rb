require 'spec_helper'

Fabricator(:user) do
  username { Faker::Name.name.downcase }
  password "secret123"
  sfdc_username { Faker::Name.name.downcase }
end

describe User do
  it "has a valid factory" do
    Fabricate(:user).should be_valid
  end

  it "requires attributes" do
    [:username, :password, :sfdc_username].each do |attr|
      model = Fabricate.build(:user, attr => nil)
      model.should have_at_least(1).error_on(attr)
    end
  end

  describe "#sfdc_login" do
    context "with valid password" do
      it "should return a access token" do
        client = mock("valid client")
        client.should_receive(:authenticate).and_return(:token)
        Databasedotcom::Client.stub!(:new).and_return(client)

        result = User.sfdc_login("foo", "secret")
        result[:success].should == 'true'
        result[:access_token].should == :token
      end
    end

    context "with bad password" do
      it "should faild" do
        client = mock("valid client")
        client.should_receive(:authenticate).and_raise(Exception)
        Databasedotcom::Client.stub!(:new).and_return(client)

        result = User.sfdc_login("foo", "secret")
        result[:success].should == 'false'
      end
    end
  end

  describe "#authenticate" do
    it "returns a new user" do
      results = stub('results')
      results.should_receive(:[]).with(:success).and_return('true')
      results.should_receive(:[]).with(:access_token).and_return(:token)
      user = mock('user')
      user.should_receive(:save).once
      User.stub!(:new).and_return(user)

      User.stub!(:sfdc_login).and_return(results)
      User.authenticate('foo', 'secret').should == user
    end

    it "returns nil if the login is invalid" do
      results = stub("results")
      results.should_receive(:[]).with(:success).and_return('false')
      User.stub!(:sfdc_login).and_return(results)
      User.authenticate('foo', 'secret').should be_nil
    end
  end

  describe "#authenticate_third_party" do
    context "with valid sfdc" do
      before do
        results = mock('results')
        results.should_receive(:[]).with(:success).and_return('true')
        results.should_receive(:[]).with(:username).at_least(:once).and_return('foo')
        results.should_receive(:[]).with(:sfdc_username).and_return('foo')

        Services.stub!(:sfdc_username).and_return(results)
      end

      it "returns user when login was success" do
        login_results = stub('login_results')
        login_results.should_receive(:[]).with(:success).and_return('true')
        login_results.should_receive(:[]).with(:access_token).and_return(:token)
        User.stub!(:sfdc_login).and_return(login_results)

        User.authenticate_third_party(1,1,1).should_not be_nil
      end

    end

  end
end
