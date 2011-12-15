class SignupCompleteForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  
  attr_accessor :email, :name, :username, :uid, :provider
  validates_presence_of :email, :name, :username, :uid, :provider
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\z/
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
end
