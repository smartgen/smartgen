module Smartgen
  class Configuration
    attr_accessor :src_files
    attr_accessor :output_folder
    attr_accessor :layout
    attr_accessor :assets
    attr_accessor :metadata_file
    
    def initialize
      @src_files = []
      @output_folder = 'tmp'
      @layout = nil
      @assets = []
      @metadata_file = 'metadata.yml'
    end
  end
end