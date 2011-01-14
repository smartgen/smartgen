require 'bluecloth'

module Smartgen
  module Engine
    class Markdown
      def process(body)
        BlueCloth.new(body).to_html
      end
      
      def supported?(extension)
        ['.md', '.markdown'].include?(extension)
      end
    end
  end
end