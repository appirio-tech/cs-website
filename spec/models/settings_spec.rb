require 'spec_helper'

describe Settings do
  let(:settings) { Settings.new }

  it "has access_token" do
    settings.should respond_to(:access_token)
  end
end
