class ResetPasswordForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  
  attr_accessor :username, :passcode, :password
  validates_presence_of :username, :passcode, :password
  validates_length_of :password, :minimum => 8
  validates_confirmation_of :password  
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
end