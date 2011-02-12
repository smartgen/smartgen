require 'active_support/core_ext/object/blank'

module Smartgen

  # A MarkupFile is created for each file that will be generated.
  #
  # It is also exposed in layouts, as +markup_file+ variable.
  #
  # It receives the +path+ of the file and process it using the first suitable
  # engine, based on the extension of the file.
  #
  # It can also receive an options hash with indexer options:
  #
  #   MarkupFile.new 'some/path', :indexer => true
  #
  # Or, if you want to pass options for the Indexer:
  #
  #   MarkupFile.new 'some/path', :indexer => { :numbered_index => true }
  #
  class MarkupFile

    # The path of the file.
    attr_accessor :path

    # The name of the file, without extension.
    attr_accessor :filename

    # The extension of the file.
    attr_accessor :extension

    # The engine used to process the file.
    attr_accessor :engine

    # The contents of the file after processing.
    attr_accessor :contents

    # The indexer instance, if +options[:indexer]+ is given
    attr_accessor :indexer

    def initialize(path, options={})
      @path = path
      @extension = File.extname(path)
      @filename = filename_for(path)
      @engine = engine_for(@extension) || self.class.engines.first

      @contents = engine.process(raw_contents, options[:metadata])

      if options[:indexer]
        @indexer = Smartgen::Indexer.new(@contents, options[:indexer])
        @contents = @indexer.result
      end

    end

    # The contents of the file before processing.
    def raw_contents
      File.read(path)
    end

    class << self
      # Returns an array with the supported engines.
      #
      # The priority of the engines is defined by their order in this array. The
      # first ones are the ones with higher priority.
      def engines
        if @engines.blank?
          @engines = [Smartgen::Engine::Textile.new, Smartgen::Engine::Markdown.new, Smartgen::Engine::ERB.new]
        end

        @engines
      end

      # Register an engine to be used when generating files.
      #
      # The engine will be added with the highest priority.
      def register(engine)
        engines.unshift engine.new
      end
    end

    private

      def engine_for(extension)
        self.class.engines.each do |engine|
          return engine if engine.supported?(extension)
        end

        nil
      end

      def filename_for(path)
        File.basename(File.basename(path, @extension), '.html')
      end
  end
end
