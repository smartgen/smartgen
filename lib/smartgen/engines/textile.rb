require 'RedCloth'

module Smartgen
  module Engine
    class Textile < Base
      protected
        def parse(body)
          RedCloth.new(body).to_html
        end

        def extensions
          @extensions ||= ['.textile']
        end
    end
  end
end