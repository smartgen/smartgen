module Smartgen
  class Resource
    def configure
      yield config
    end
  
    def config
      @config ||= Smartgen::Configuration.new
    end
  end
end