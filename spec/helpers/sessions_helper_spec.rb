require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe SessionsHelper do
  let (:user) { stub_model(User, :id => 1, :username => 'kerdosa', :password => "kerdosa01")}
  
  it "should set remember_token in sign_in" do
    # helper.sign_in(user)
    helper.current_user = user
    helper.current_user.should == user
  end
end
