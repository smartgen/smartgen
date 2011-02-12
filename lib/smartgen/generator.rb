require 'thor/group'

module Smartgen
  # Generates files, possibly using layout and copying assets.
  class Generator < Thor::Group
    include Thor::Actions

    desc "Process given markup files, generating HTML, optionally using a layout and copying assets."

    argument :src_files, :type => :array,
             :desc => "An array with all the source files that should be generated."

    argument :output_folder, :type => :string,
             :desc => "The output folder, where all generated files will be located."

    class_option :layout, :type => :string,
                 :desc => "An optional layout file to be used when rendering each page."

    class_option :assets, :type => :array, :default => [],
                 :desc => "An array of dirs to be copied to output folder."

    class_option :metadata_file, :type => :string,
                 :desc => "A YAML metadata file used to specify metadata used in all pages, or even specific page metadata."

    class_option :use_indexer, :type => :boolean, :default => false,
                 :desc => "Whether indexer should be used or not."

    class_option :numbered_index, :type => :boolean, :default => false,
                 :desc => "Whether indexer should add numbered indexes on header tags."

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
      # Returns the current renderer.
      def renderer
        @renderer ||= Smartgen::Renderer::ERB.new
      end

      # Sets the renderer used when generating files.
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
        add_current_page_data_to(markup_file)
        metadata
      end

      def metadata
        @metadata ||= load_metadata
      end

      def load_metadata
        if options["metadata_file"]
          YAML.load(File.read(options["metadata_file"]))
        else
          {}
        end
      end

      def add_current_page_data_to(markup_file)
        if metadata.has_key?("pages")
          metadata["current_page"] = page_metadata(markup_file) || {}
        end
      end

      def page_metadata(markup_file)
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
        if options[:numbered_index]
          { :indexer => { :numbered_index => true }, :metadata => metadata }
        else
          { :indexer => options[:use_indexer], :metadata => metadata  }
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
