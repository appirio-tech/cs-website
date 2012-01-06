require 'spec_helper'

describe ContactForm do
  it "requires name" do
    ContactForm.new(:name => nil).should_not be_valid
  end

  it "requires content" do
    ContactForm.new(:content => nil).should_not be_valid
  end

  it "requires email" do
    ContactForm.new(:email => nil).should_not be_valid
  end

  it "handles initialization properly" do
    form = ContactForm.new(:name => "foo", :email => "foo@example.com", :content => "foo")
    form.should be_valid
  end

  it "is never persisted" do
    ContactForm.new.should_not be_persisted
  end
end
