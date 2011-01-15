require 'active_support/core_ext/hash/indifferent_access'

module Smartgen
  class ObjectHash < HashWithIndifferentAccess
    def dup
      Smartgen::ObjectHash.new(self)
    end
    
    def respond_to?(method)
      has_key?(method) or super
    end
    
    protected
      def method_missing(name, *args)
        if has_key?(name)
          self[name]
        else
          super
        end
      end
      
      def convert_value(value)
        case value
        when Hash
          value.with_object_hash
        when Array
          value.collect { |e| e.is_a?(Hash) ? e.with_object_hash : e }
        else
          value
        end
      end
  end
end

class Hash
  include ActiveSupport::CoreExtensions::Hash::IndifferentAccess
  
  def with_object_hash
    hash = Smartgen::ObjectHash.new(self)
    hash.default = self.default
    hash
  end
end
