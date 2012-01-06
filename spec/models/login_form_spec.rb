require 'spec_helper'

describe LoginForm do
  it "requires username" do
    LoginForm.new(:username => nil).should_not be_valid
  end

  it "has a length limit on username" do
    LoginForm.new(:username => "#{'s' * 50}").should have_at_least(1).error_on(:username)
  end

  it "requires password" do
    LoginForm.new(:password => nil).should_not be_valid
  end

  it "has a length limit on password" do
    LoginForm.new(:password => "#{'s' * 50}").should have_at_least(1).error_on(:username)
  end

  it "handles initialization properly" do
    form = LoginForm.new(:username => "foo", :password => "secret")
    form.should be_valid
  end

  it "is never persisted" do
    LoginForm.new.should_not be_persisted
  end
end
