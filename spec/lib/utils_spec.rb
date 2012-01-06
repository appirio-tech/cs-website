require 'spec_helper'


describe Utils do
  describe "#public_access_token" do
    context "with settings older less than an hour" do
      it "returns the access token" do
        Settings.stub!(:first).and_return(stub(:created_at => 10.minutes.ago, :access_token => :token))
        # there shouldn't be any need to load config
        YAML.should_receive(:load_file).never
        Utils.public_access_token.should == :token
      end
    end

    context "with settings older than an hour" do
      it "reloads the access token from the database" do
        settings = mock("first settings", :created_at => 2.hours.ago)
        settings.should_receive(:destroy).once
        Settings.stub!(:first).and_return(settings)

        Databasedotcom::Client.stub!(:new).and_return(stub(:authenticate => :token))
        Utils.public_access_token.should == :token
      end

      it "returns nil when client is unable to authenticate" do
        settings = mock("first settings", :created_at => 2.hours.ago)
        Settings.stub!(:first).and_return(settings)

        client = stub("invalid client")
        client.should_receive(:authenticate).and_raise(Exception)
        Databasedotcom::Client.stub!(:new).and_return(client)
        Utils.public_access_token.should be_nil
      end
    end
  end

  describe "#send_mail" do
    it "queues an email" do
      p = { :email => "foo@example.com", :name => "John Doe", :content => "foo",
        :subject => "foo" }
      Resque.should_receive(:enqueue).once
      Utils.send_mail(p)
    end
  end
end
