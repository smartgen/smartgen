module Smartgen
  
  # A Resource holds a Configuration used when generating files.
  #
  # You create a resource and configure it like this:
  #
  #   Smartgen[:my_resource].configure do |config|
  #     config.src_files = ['docs/**/*']
  #     config.output_folder = 'public/docs'
  #   end
  # 
  # To generate files, just call Resource#generate! on it:
  #
  #   Smartgen[:my_resource].generate!
  class Resource
    
    # Yields a Configuration, so that you can configure the generation of files.
    def configure
      yield config if block_given?
    end
  
    # Returns the Configuration for this resource.
    def config
      @config ||= Smartgen::Configuration.new
    end
    
    # Generate files, based on the current Configuration.
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