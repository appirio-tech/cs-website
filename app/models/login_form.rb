class LoginForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  
  attr_accessor :username, :password
  validates_presence_of :username, :password
  validates_length_of :username, :maximum => 25
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
end