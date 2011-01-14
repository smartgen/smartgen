require 'RedCloth'

module Smartgen
  module Engine
    class Textile
      def process(body)
        RedCloth.new(body).to_html
      end
      
      def supported?(extension)
        ['.textile'].include?(extension)
      end
    end
  end
end