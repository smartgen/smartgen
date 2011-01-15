require "active_support/inflector"
require 'active_support/core_ext/object/blank'

module Smartgen
  class MarkupFile
    attr_accessor :path, :filename, :extension, :file, :engine
    
    def initialize(path)
      @path = path
      @extension = File.extname(path)
      @filename = File.basename(path, @extension)
      @engine = engine_for(@extension) || self.class.engines.first
    end
    
    def raw_contents
      File.read(path)
    end
    
    def contents
      engine.process(raw_contents)
    end
    
    class << self
      def engines
        if @engines.blank?
          @engines = [Smartgen::Engine::Textile.new, Smartgen::Engine::Markdown.new]
        end
        
        @engines
      end
      
      def register(engine)
        engines.unshift engine.new
      end
    end
    
    private
    
      def engine_for(extension)
        self.class.engines.each do |engine|
          return engine if engine.supported?(extension)
        end
        
        nil
      end
  end
end