# This extends String to add the +resourcerize+ method.
class String

  # Dasherizes and downcases a camelcased string. Used for Feed types.
  def resourcerize
    self.gsub(/([a-z])([A-Z])/, '\1-\2').downcase
  end

def constantize
    unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ self
      raise NameError, "#{self.inspect} is not a valid constant name!"
    end
    Object.module_eval("::#{$1}", __FILE__, __LINE__)
  end

end
