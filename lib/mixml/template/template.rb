require 'erubis'

module Mixml
    module Template
        class Template
            attr_reader :text

            def initialize(text)
                @text = text
            end

            def evaluate(node)
                template = Erubis::Eruby.new(@text, :pattern => '{ }')
                context = {:node => node}
                template.result(context)
            end
        end
    end
end
