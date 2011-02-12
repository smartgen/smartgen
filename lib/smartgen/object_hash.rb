require 'active_support/core_ext/hash'

module Smartgen
  # A hash that has method accessors for each key.
  #
  # For example:
  #   hash = ObjectHash.new({:foo => 'bar'})
  #   puts hash.foo     # outputs 'bar'
  #
  class ObjectHash < HashWithIndifferentAccess
    def dup
      Smartgen::ObjectHash.new(self)
    end

    def respond_to?(method)
      has_key?(method) || (setter?(method) && has_key?(method.to_s.chop)) || super
    end

    def inspect
      "ObjectHash(#{super})"
    end

    protected
      def method_missing(name, *args)
        if has_key?(name)
          self[name]
        elsif setter?(name)
          self[name.to_s.chop] = args.first
        else
          puts "warning: key #{name} not found on #{inspect}"
          Smartgen::ObjectHash.new
        end
      end

      def setter?(method)
        method.to_s.end_with?('=')
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

class Hash # :nodoc: all
  def with_object_hash
    hash = Smartgen::ObjectHash.new(self)
    hash.default = self.default
    hash
  end
end
