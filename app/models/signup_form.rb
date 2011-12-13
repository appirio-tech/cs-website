class SignupForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :username, :email, :password, :terms_of_service
  validates_presence_of :username, :email, :password
  validates_acceptance_of :terms_of_service  
  validates_format_of :username, :without => /\s/, :message => 'cannot contain spaces'
  validates_length_of :username, :maximum => 25
  validates_length_of :password, :minimum => 8
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\z/
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