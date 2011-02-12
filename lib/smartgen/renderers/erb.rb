module Smartgen
  module Renderer
    # A renderer that uses ERB to render markup files.
    class ERB
      # Renders the markup file using the given layout.
      #
      # It exposes +markup_file+ variable and its +metadata+ to the ERB layout.
      def render(layout, markup_file, metadata={})
        ::ERB.new(layout).result(binding)
      end
    end
  end
end