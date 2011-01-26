module Smartgen
  module Renderer
    # A renderer that uses ERB to render markup files.
    class ERB
      # Renders the markup file using the given layout.
      #
      # It exposes +markup_file+ variable and its +metadata+ to the ERB layout.
      def render(layout, markup_file, metadata={})
        metadata = Smartgen::ObjectHash.new(metadata)

        template = ::ERB.new(layout)
        template.result(binding)
      end
    end
  end
end