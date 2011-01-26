require 'RedCloth'

module Smartgen
  module Engine
    # Processes textile files, supporting '.textile' extension.
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