require 'RedCloth'

module Smartgen
  module Engine
    class Textile
      def process(body)
        RedCloth.new(body).to_html
      end
      
      def supported?(extension)
        extensions.include?(extension)
      end
      
      def extensions
        @extensions ||= ['.textile']
      end
    end
  end
end