require 'active_support/core_ext/class/inheritable_attributes'

module Smartgen
  module Engine
    class Base
      class_inheritable_accessor :pre_processors
      
      def initialize
        self.pre_processors ||= []
      end
      
      def process(body)
        parse(pre_process(body))
      end
      
      def supported?(extension)
        extensions.include?(extension)
      end
      
      class << self
        def register(processor)
          self.pre_processors ||= []
          self.pre_processors << processor
        end
      end
      
      protected
        def pre_process(body)
          self.pre_processors.inject(body) do |processed_body, pre_processor|
            processed_body = pre_processor.process(processed_body)
            processed_body
          end
        end

        def parse(body)
          body
        end

        def extensions
          []
        end
    end
  end
end