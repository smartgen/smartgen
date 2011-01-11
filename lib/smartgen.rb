# -*- encoding: utf-8 -*-
require File.expand_path(File.join('smartgen', 'resource'), File.dirname(__FILE__))
require File.expand_path(File.join('smartgen', 'configuration'), File.dirname(__FILE__))
require File.expand_path(File.join('smartgen', 'markup_file'), File.dirname(__FILE__))
require File.expand_path(File.join('smartgen', 'generator'), File.dirname(__FILE__))

module Smartgen
  MARKUP_ENGINES_MAPPING = { :markdown => ['.markdown', '.md'], :textile => ['.textile'] }
  
  class << self
    def [](name)
      resources[name] ||= Smartgen::Resource.new
    end

    private
      def resources
        @resources ||= {}
      end
  end
end
