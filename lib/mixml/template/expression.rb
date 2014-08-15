require 'mixml/template/base'
require 'erubis'

module Mixml
    # Module for template classes
    module Template
        # Eruby based template
        class Expression < Base
            # @return [Erubis::Eruby] Template expression
            attr_reader :expression

            # Initialize a new template
            #
            # @param [String] text Template text
            def initialize(text)
                @expression = Erubis::Eruby.new(text, :pattern => '{ }')
            end

            # Evaluate the template
            #
            # @param [Nokogiri::XML::Node] node Current node
            # @return [String] Template result
            def evaluate(node)
                context = {:node => node}
                @expression.result(context)
            end
        end
    end
end
