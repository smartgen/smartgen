#!/usr/bin/env ruby

require 'rake'
require 'rake/tasklib'
require 'smartgen'

module Smartgen
  class RakeTask < ::Rake::TaskLib
    def initialize(name=nil, &block)
      name = name || :smartgen
      
      Smartgen[name].configure(&block)
      
      desc("Generate smartgen files") unless ::Rake.application.last_comment
      task name do
        Smartgen[name].generate!
      end
    end
  end
end
