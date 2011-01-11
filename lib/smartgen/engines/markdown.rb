require 'bluecloth'

module Smartgen
  module Engine
    class Markdown
      def process(body)
        BlueCloth.new(body).to_html
      end
    end
  end
end