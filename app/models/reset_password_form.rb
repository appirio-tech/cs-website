class ResetPasswordForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  
  attr_accessor :username, :passcode, :new_password, :new_password_again
  validates_presence_of :username, :passcode, :new_password, :new_password_again
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
end