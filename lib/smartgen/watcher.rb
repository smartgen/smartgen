require 'directory_watcher'

module Smartgen
  # Watches for changes in configured files and regenerated them as they are changed.
  #
  # Just pass the name of the resource to it and call #start. It will generate
  # the files right away and it will keep watching for changes in those files.
  # Every time a file is added, changed or removed, it will regenerate all
  # files.
  #
  # You can also pass a block when initializing to create and configure the
  # resource.
  #
  # For example:
  #
  #   watcher = Smartgen::Watcher.new :my_resource do |config|
  #     config.src_files = ['docs/**/*']
  #     config.output_folder = 'public_docs'
  #   end
  #
  #   watcher.start
  class Watcher
    attr_accessor :name
    
    def initialize(name, &block)
      @name = name
      configure(&block)
    end
    
    # Starts watching files for changes.
    def start
      puts "Watching these files for changes #{glob}..."
      configure_directory_watcher
      setup_graceful_exit
      
      directory_watcher.start.join
    end
    
    # Generate files.
    def generate(*args)
      puts "Regenerating files, #{args.size} files have been added/changed/removed."
      Smartgen[@name].generate!
      puts "Files generated."
    end
    
    private
      def resource
        Smartgen[name]
      end
    
      def configure(&block)
        resource.configure(&block)
      end
      
      def directory_watcher
        @directory_watcher ||= DirectoryWatcher.new '.', :glob => glob
      end
      
      def glob
        resource.config.src_files
      end
      
      def configure_directory_watcher
        directory_watcher.interval = 2
        directory_watcher.add_observer self, :generate
      end
    
      def setup_graceful_exit
        Kernel.trap 'INT' do
          puts "Stopping watcher..."
          Kernel.exit 0
        end
      end
  end
end