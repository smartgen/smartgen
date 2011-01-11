module Smartgen
  class Resource
    def configure
      yield config
    end
  
    def config
      @config ||= Smartgen::Configuration.new
    end
    
    def generate!
      generator.invoke_all
    end
    
    private
      def generator
        Smartgen::Generator.new(arguments, options)
      end
      
      def arguments
        [config.src_files, config.output_folder]
      end
      
      def options
        {
          :metadata_file => config.metadata_file,
          :layout => config.layout,
          :assets => config.assets
        }
      end
  end
end