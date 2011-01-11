require "active_support/i18n"
require "active_support/inflector"

module Smartgen
  class MarkupFile
    attr_accessor :path, :filename, :extension, :file, :engine
    
    def initialize(path)
      @path = path
      @extension = File.extname(path)
      @filename = File.basename(path, @extension)
      @engine = engine_for(@extension) || create_engine(:textile)
    end
    
    def raw_contents
      File.read(path)
    end
    
    def contents
      engine.process(raw_contents)
    end
    
    private
    
      def engine_for(ext)
        Smartgen::MARKUP_ENGINES_MAPPING.each do |engine, extensions|
          return create_engine(engine) if extensions.include?(ext)
        end
        
        nil
      end
      
      def create_engine(engine)
        "smartgen/engine/#{engine}".camelize.constantize.new
      end
  end
end