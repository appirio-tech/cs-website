require 'spec_helper'

describe ResetPasswordAccountForm do

  it "requires password" do
    ResetPasswordAccountForm.new(:password => nil).should_not be_valid
  end

  it "requires long password" do
    form = ResetPasswordAccountForm.new(:password => "secret")
    form.should have_at_least(2).errors_on(:password)
  end

  it "is never persisted" do
    ResetPasswordAccountForm.new.should_not be_persisted
  end
end
