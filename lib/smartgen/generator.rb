require 'thor/group'

module Smartgen
  class Generator < Thor::Group
    include Thor::Actions
    
    argument :src_files, :type => :array
    argument :output_folder, :type => :string
    
    class_option :layout, :type => :string
    class_option :assets, :type => :array, :default => []
    
    attr_reader :loaded_files
    
    def create_output_folder
      destination_root = output_folder
      empty_directory output_folder
    end
    
    def generate_files
      markup_files.each do |markup_file|
        create_file output_folder_path("#{markup_file.filename}.html"), process_file(markup_file), :force => true
      end
    end
    
    def copy_assets
      options[:assets].each do |dir|
        self.class.source_root File.dirname(dir)
        directory File.basename(dir), output_folder_path(File.basename(dir)), :force => true
      end
    end
    
    class << self
      def renderer
        @renderer ||= Smartgen::Renderer::ERB.new
      end
      
      def renderer=(value)
        @renderer = value
      end
    end
    
    private
    
      def process_file(markup_file)
        if has_layout?
          self.class.renderer.render(layout, markup_file)
        else
          markup_file.contents
        end
      end
      
      def has_layout?
        options.has_key?("layout")
      end
      
      def layout
        File.read(options["layout"])
      end
    
      def markup_files
        Dir[*src_files].select { |f| supported?(File.extname(f)) }.map do |markup_filename|
          MarkupFile.new markup_filename
        end
      end
      
      def supported?(extension)
        MarkupFile.engines.one? { |engine| engine.supported?(extension) }
      end
      
      def output_folder_path(path)
        File.join(output_folder, path)
      end
  end
end