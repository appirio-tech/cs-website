require 'spec_helper'

Fabricator(:signup_form) do
  email { Faker::Internet.email }
  username { Faker::Name.name.downcase }
  password "secret123"
end

describe SignupForm do
  it "has a valid factory" do
    Fabricate(:signup_form).should be_valid
  end

  it "requires attributes" do
    [:username, :email, :password].each do |attr|
      model = Fabricate(:signup_form, attr => nil)
      model.should have_at_least(1).error_on(attr)
    end
  end
  
  it "requires a valid email" do
    %w{foo foobar foo@bar @foobar}.each do |email|
      model = Fabricate(:signup_form, :email => email)
      model.should have_at_least(1).error_on(:email)
    end
  end

  it "has a length limit on username" do
    model = Fabricate(:signup_form, :username => "#{'a' * 50}")
    model.should have_at_least(1).error_on(:username)
  end

  it "is never persisted" do
    SignupForm.new.should_not be_persisted
  end
end
