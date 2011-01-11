module Smartgen
  class MarkupFile
    attr_accessor :path, :filename, :extension, :file, :engine
    
    def initialize(path)
      @path = path
      @extension = File.extname(path)
      @filename = File.basename(path, @extension)
      @engine = engine_for(@extension) || :textile
    end
    
    def raw_contents
      File.read(path)
    end
    
    private
    
      def engine_for(ext)
        Smartgen::MARKUP_ENGINES_MAPPING.each do |engine, extensions|
          return engine if extensions.include?(ext)
        end
        
        nil
      end
  end
end