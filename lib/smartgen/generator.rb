require 'thor/group'

module Smartgen
  class Generator < Thor::Group
    include Thor::Actions
    
    argument :src_files, :type => :array
    argument :output_folder, :type => :string
    
    attr_reader :loaded_files
    
    def create_output_folder
      empty_directory output_folder
    end
    
    def generate_files
      markup_files.each do |markup_file|
        create_file output_folder_path("#{markup_file.filename}.html"), process_file(markup_file)
      end
    end
    
    private
    
      def process_file(markup_file)
        markup_file.contents
      end
    
      def markup_files
        Dir[*src_files].select { |f| markup_extensions.include?(File.extname(f)) }.map do |markup_filename|
          MarkupFile.new markup_filename
        end
      end
      
      def markup_extensions
        Smartgen::MARKUP_ENGINES_MAPPING.map { |m, exts| exts }.flatten
      end
      
      def output_folder_path(path)
        File.join(output_folder, path)
      end
  end
end