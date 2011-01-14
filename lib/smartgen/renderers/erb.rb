module Smartgen
  module Renderer
    class ERB
      def render(layout, markup_file, metadata={})
        template = ::ERB.new(layout)
        template.result(binding)
      end
    end
  end
end