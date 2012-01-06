require 'spec_helper'

describe Settings do
  it "requires access token" do
    Settings.new(:access_token => nil).should_not be_valid
  end
end
