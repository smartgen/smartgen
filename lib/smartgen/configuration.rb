module Smartgen
  
  # Holds configurations for each smartgen resource.
  class Configuration
    
    # An array with all the source files that should be generated.
    #
    # Each entry may be a glob, such as 'doc/**/*'. Only files with extensions
    # supported by the registered engines will be used. Files without extensions
    # will be used as well, but they will use the highest priority engine.
    #
    # default:
    #   []
    attr_accessor :src_files
    
    # The output folder, where all generated files will be located.
    #
    # default:
    #   nil
    attr_accessor :output_folder
    
    # An optional layout file to be used when rendering each page.
    #
    # default:
    #   nil
    attr_accessor :layout
    
    # An array of dirs to be copied to output folder.
    #
    # It will copy the contents of each directory to the output folder,
    # preserving the directory itself. So, if output folder is '/public/doc',
    # then 'doc/stylesheets' will be copied to 'public/docs/stylesheets'.
    #
    # default:
    #   []
    attr_accessor :assets
    
    # A YAML metadata file used to specify metadata used in all pages, or even
    # specific page metadata.
    #
    # default:
    #   nil
    attr_accessor :metadata_file
    
    # Whether indexer should be used or not.
    #
    # default:
    #   false
    attr_accessor :use_indexer
    
    # Whether indexer should add numbered indexes on header tags.
    #
    # Only makes sense if #use_indexer is true
    #
    # default:
    #   false
    attr_accessor :numbered_index
    
    def initialize
      @src_files = []
      @output_folder = nil
      @layout = nil
      @assets = []
      @metadata_file = nil
      @use_indexer = false
      @numbered_index = false
    end
  end
end