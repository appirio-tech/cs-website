require 'active_record'

class OpenidAbstract < ActiveRecord::Base
  self.abstract_class = true
end
