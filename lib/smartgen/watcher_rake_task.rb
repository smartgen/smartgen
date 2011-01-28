#!/usr/bin/env ruby

require 'rake'
require 'rake/tasklib'
require 'smartgen'

module Smartgen
  # A rake task that starts a watcher for file changes and generate them on
  # demand, using smartgen.
  #
  # To use it, require this file instead of +smartgen+:
  #
  #   require 'smartgen/watcher_rake_task'
  #
  # Then create the task and configuration:
  #
  #   Smartgen::WatcherRakeTask.new :generate_doc do |config|
  #     config.src_files = ['doc/**/*']
  #     config.output_folder = 'public/doc'
  #   end
  #
  # It yields a Configuration, in fact it calls Resource#configure, so you
  # can use any of the configurations here.
  #
  # When you run this task it will start the watcher and wait for file changes,
  # just go editing your files, and it will regenerate them as you change files.
  #
  # You may also use an existing configuration, while still having a different
  # task name:
  #
  #   Smartgen::WatcherRakeTask.new :watcher, :generate_doc do |config|
  #     config.src_files = ['doc/**/*']
  #     config.output_folder = 'public/doc'
  #   end
  #
  # This will use Smartgen[:generate_doc] config, but you will call it with:
  #
  #   rake watcher
  class WatcherRakeTask < ::Rake::TaskLib
    def initialize(resource_or_task_name=nil, resource_name=nil, &block)
      task_name = resource_or_task_name || 'smartgen:watcher'
      resource_name = resource_name || task_name
      
      watcher = Smartgen::Watcher.new resource_name, &block
      
      desc("Watches for changes in files and generate them using smartgen") unless ::Rake.application.last_comment
      task task_name do
        watcher.start
      end
    end
  end
end
