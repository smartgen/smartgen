# -*- encoding: utf-8 -*-
require File.expand_path(File.join('smartgen', 'object_hash'), File.dirname(__FILE__))
require File.expand_path(File.join('smartgen', 'resource'), File.dirname(__FILE__))
require File.expand_path(File.join('smartgen', 'configuration'), File.dirname(__FILE__))
require File.expand_path(File.join('smartgen', 'watcher'), File.dirname(__FILE__))
require File.expand_path(File.join('smartgen', 'indexer'), File.dirname(__FILE__))
require File.expand_path(File.join('smartgen', 'markup_file'), File.dirname(__FILE__))
require File.expand_path(File.join('smartgen', 'renderers'), File.dirname(__FILE__))
require File.expand_path(File.join('smartgen', 'engines'), File.dirname(__FILE__))
require File.expand_path(File.join('smartgen', 'generator'), File.dirname(__FILE__))

# Smartgen generates HTML files from markup files, possibly using layouts.
module Smartgen
  class << self
    # Returns a resouces with the given name, creating it if necessary.
    def [](name)
      resources[name] ||= Smartgen::Resource.new
    end

    private
      def resources
        @resources ||= {}
      end
  end
end
