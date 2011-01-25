require 'thor/group'

module Smartgen
  class Generator < Thor::Group
    include Thor::Actions
    
    argument :src_files, :type => :array
    argument :output_folder, :type => :string
    
    class_option :layout, :type => :string
    class_option :assets, :type => :array, :default => []
    class_option :metadata_file, :type => :string
    class_option :use_indexer, :type => :boolean, :default => false
    
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
          self.class.renderer.render(layout, markup_file, metadata_for(markup_file))
        else
          markup_file.contents
        end
      end
      
      def has_layout?
        options["layout"].present?
      end
      
      def layout
        File.read(options["layout"])
      end
      
      def metadata_for(markup_file)
        metadata = load_metadata
        add_current_page_data_to(metadata, markup_file)
        metadata
      end
      
      def load_metadata
        if options["metadata_file"]
          YAML.load(File.read(options["metadata_file"]))
        else
          {}
        end
      end
      
      def add_current_page_data_to(metadata, markup_file)
        if metadata.has_key?("pages")
          metadata["current_page"] = page_metadata(metadata, markup_file) || {}
        end
      end
      
      def page_metadata(metadata, markup_file)
        metadata["pages"].select { |page| current_page?(page, markup_file) }.first
      end
    
      def current_page?(page, markup_file)
        page.has_key?("file") && page["file"] == markup_file.filename
      end
      
      def markup_files
        Dir[*src_files].select { |f| supported?(File.extname(f)) }.map do |markup_filename|
          MarkupFile.new markup_filename, markup_file_options
        end
      end
      
      def markup_file_options
        { :indexer => options[:use_indexer] }
      end
      
      def supported?(extension)
        MarkupFile.engines.one? { |engine| engine.supported?(extension) }
      end
      
      def output_folder_path(path)
        File.join(output_folder, path)
      end
  end
end