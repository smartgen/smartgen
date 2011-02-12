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
  #
  # You may also use an existing configuration, while still having a different
  # task name:
  #   Smartgen[:my_config] do |config|
  #     config.layout = 'layout.html.erb'
  #   end
  #
  #   Smartgen::RakeTask.new :watcher, :my_config do |config|
  #     config.src_files = ['doc/**/*']
  #     config.output_folder = 'public/doc'
  #   end
  #
  # This will use Smartgen[:generate_doc] config, but you will call it with:
  #
  #   rake watcher
  class RakeTask < ::Rake::TaskLib
    def initialize(resource_or_task_name=nil, resource_name=nil, &block)
      task_name = resource_or_task_name || :smartgen
      resource_name = resource_name || task_name
      
      Smartgen[resource_name].configure(&block)
      
      desc("Generate smartgen files") unless ::Rake.application.last_comment
      task task_name do
        Smartgen[resource_name].generate!
      end
    end
  end
end
