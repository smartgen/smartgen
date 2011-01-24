require 'bluecloth'

module Smartgen
  module Engine
    class Markdown < Base
      protected
        def parse(body)
          BlueCloth.new(body).to_html
        end

        def extensions
          @extensions ||= ['.md', '.markdown']
        end
    end
  end
end