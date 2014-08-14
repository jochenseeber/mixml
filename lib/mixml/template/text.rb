module Mixml
    module Template
        class Text
            attr_reader :text

            def initialize(text)
                @text = text
            end

            def evaluate(node)
                @text
            end
        end
    end
end
