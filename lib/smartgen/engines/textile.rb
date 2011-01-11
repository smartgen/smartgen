require 'RedCloth'

module Smartgen
  module Engine
    class Textile
      def process(body)
        RedCloth.new(body).to_html
      end
    end
  end
end