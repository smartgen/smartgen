module Smartgen
  module Engine
    # Processes erb files, supporting '.erb' extension.
    class ERB < Base
      protected
        def parse(body, metadata)
          ::ERB.new(body).result(binding)
        end

        def extensions
          @extensions ||= ['.erb']
        end
    end
  end
end