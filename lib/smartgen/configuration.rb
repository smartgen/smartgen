module Smartgen
  # Holds configurations for each smartgen resource.
  class Configuration < ObjectHash
    
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
  end
end