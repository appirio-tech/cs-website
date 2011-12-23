class AtomEntry
  include ActiveModel::Validations
  include ActiveModel::Conversion
  
  attr_accessor :id, :title, :content
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
end