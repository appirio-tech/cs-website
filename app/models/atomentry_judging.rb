class AtomEntryJudging
  include ActiveModel::Validations
  include ActiveModel::Conversion
  
  attr_accessor :id, :title, :due_date, :end_date, :categories
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
end