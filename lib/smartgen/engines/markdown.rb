require 'bluecloth'

module Smartgen
  module Engine
    # Processes markdown files, supporting both '.md' and '.markdown' extensions.
    class Markdown < Base
      protected
        def parse(body, metadata)
          BlueCloth.new(body).to_html
        end

        def extensions
          @extensions ||= ['.md', '.markdown']
        end
    end
  end
end