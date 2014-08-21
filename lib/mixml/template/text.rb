require 'mixml/template/base'

module Mixml
    module Template
        # Ruby string template
        class Text < Base
            # @return [String] Template text
            attr_reader :text

            # Initialize a new template
            #
            # @param text [String] Template text
            def initialize(text)
                raise(ArgumentError, 'Text must not be nil.') if text.nil?

                @text = '"' << text.gsub('"', '\"') << '"'
            end

            # Evaulate the template using Ruby string interpolation
            #
            # @param node [Nokogiri::XML::Node] Current node
            def evaluate(node)
                eval(@text, binding)
            end
        end
    end
end
