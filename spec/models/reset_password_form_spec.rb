require 'spec_helper'

describe ResetPasswordForm do

  it "requires password" do
    ResetPasswordForm.new(:password => nil).should_not be_valid
  end

  it "requires passcode" do
    ResetPasswordForm.new(:passcode => nil).should_not be_valid
  end

  it "requires long password" do
    form = ResetPasswordForm.new(:password => "secret")
    form.should have_at_least(2).errors_on(:password)
  end

  it "is never persisted" do
    ResetPasswordForm.new.should_not be_persisted
  end
end
