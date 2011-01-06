# -*- encoding: utf-8 -*-
require File.expand_path(File.join('smartgen', 'generator'), File.dirname(__FILE__))

module Smartgen
  class << self
    def [](name)
      generators[name] ||= Smartgen::Generator.new
    end

    private
      def generators
        @generators ||= {}
      end
  end
end
