require 'spec_helper'

describe SignupCompleteForm do
  it "has a valid factory" do
    Fabricate(:signup_complete_form).should be_valid
  end

  it "requires attributes" do
    [:email, :name, :username, :uid, :provider].each do |attr|
      model = Fabricate(:signup_complete_form, attr => nil)
      model.should have_at_least(1).error_on(attr)
    end
  end
  
  it "requires a valid email" do
    %w{foo foobar foo@bar @foobar}.each do |email|
      model = Fabricate(:signup_complete_form, :email => email)
      model.should have_at_least(1).error_on(:email)
    end
  end

  it "is never persisted" do
    ResetPasswordForm.new.should_not be_persisted
  end
end
