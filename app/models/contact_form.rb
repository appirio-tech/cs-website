class ContactForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  
  attr_accessor :name, :email, :content
  validates_presence_of :name, :email, :content
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
end