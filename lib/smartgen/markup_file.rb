require 'active_support/core_ext/object/blank'

module Smartgen
  class MarkupFile
    attr_accessor :path, :filename, :extension, :engine, :contents, :indexer
    
    def initialize(path, options={})
      @path = path
      @extension = File.extname(path)
      @filename = File.basename(path, @extension)
      @engine = engine_for(@extension) || self.class.engines.first
      
      @contents = engine.process(raw_contents)
      
      if options[:indexer]
        @indexer = Smartgen::Indexer.new(@contents, options[:indexer])
        @contents = @indexer.result
      end
    end
    
    def raw_contents
      File.read(path)
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