# This extends Class to be able to use +cattr_accessor+ if active_support is not being used.
class Class
  unless respond_to?(:cattr_reader)
    def cattr_reader(sym)
      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}
          @@#{sym}
        end

        def #{sym}
          @@#{sym}
        end
      EOS
    end

    def cattr_writer(sym)
      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}=(obj)
          @@#{sym} = obj
        end

        def #{sym}=(obj)
          @@#{sym} = obj
        end
      EOS
    end

    def cattr_accessor(*syms, &blk)
      cattr_reader(*syms)
      cattr_writer(*syms, &blk)
    end
  end
end
