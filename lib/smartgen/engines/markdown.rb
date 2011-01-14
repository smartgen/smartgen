require 'bluecloth'

module Smartgen
  module Engine
    class Markdown
      def process(body)
        BlueCloth.new(body).to_html
      end
      
      def supported?(extension)
        extensions.include?(extension)
      end
      
      def extensions
        @extensions ||= ['.md', '.markdown']
      end
    end
  end
end