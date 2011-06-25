require 'active_support/core_ext/class/inheritable_attributes'

module Smartgen
  module Engine
    # Base class for engines.
    #
    # An engine process markup files, converting them to HTML.
    class Base
      # An array of pre processors that will process files before conversion.
      class_inheritable_accessor :pre_processors

      def initialize
        self.pre_processors ||= []
        self.pre_processors.each do |pre_processor|
          pre_processor.engine = self if pre_processor.respond_to?(:engine=)
        end
      end

      # Process a file, calling each pre processor if any.
      def process(body, metadata=Smartgen::ObjectHash.new)
        process_without_pre_processors(pre_process(body, metadata), metadata)
      end

      def process_without_pre_processors(contents, metadata=Smartgen::ObjectHash.new)
        parse(contents, metadata)
      end

      # Returns true if the given extension is supported by this engine.
      def supported?(extension)
        extensions.include?(extension)
      end

      class << self
        # Registers a pre processor for this engine.
        def register(processor)
          self.pre_processors ||= []
          self.pre_processors << processor
        end
      end

      protected
        def pre_process(body, metadata={})
          self.pre_processors.inject(body) do |processed_body, pre_processor|
            processed_body = pre_processor.process(processed_body, metadata)
            processed_body
          end
        end

        def parse(body, metadata)
          body
        end

        def extensions
          []
        end
    end
  end
end
