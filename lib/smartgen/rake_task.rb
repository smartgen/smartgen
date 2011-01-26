#!/usr/bin/env ruby

require 'rake'
require 'rake/tasklib'
require 'smartgen'

module Smartgen
  # A rake task that generate files using smartgen.
  #
  # To use it, require this file instead of +smartgen+:
  #
  #   require 'smartgen/rake_task'
  #
  # Then create the task and configuration:
  #
  #   Smartgen::RakeTask.new :generate_doc do |config|
  #     config.src_files = ['doc/**/*']
  #     config.output_folder = 'public/doc'
  #   end
  #
  # It yields a Configuration, in fact it calls Resource#configure, so you
  # can use any of the configurations here.
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
