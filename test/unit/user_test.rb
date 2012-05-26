require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "should not save" do
    user = User.new
    assert !user.save, "Saved the user without all required fields"
  end
  
  test "should save" do
    user = User.new
    user.username = 'me'
    user.password = 'mypass'
    user.sfdc_username = 'me@something.com'
    assert user.save, "Could not save the user"
  end
  
  test "should not save without @ in sfdc_username" do
    #user = users(:one)
    user = User.new
    user.username = 'me'
    user.password = 'mypass'
    user.sfdc_username = 'mesomething.com'
    assert !user.save, "Saved the user without a correctly formatted sfdc_username"
  end  

end
