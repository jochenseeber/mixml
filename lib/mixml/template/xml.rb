require 'mixml/template/base'
require 'erubis'

module Mixml
    # Module for template classes
    module Template
        # XML builder based template
        class Xml < Base
            # Evaluate the template
            #
            # @param [Nokogiri::XML::Node] node Current node
            # @return [String] Template result
            def evaluate(node)
                builder = Nokogiri::XML::Builder.new do |xml|
                    yield(node, xml)
                end
                builder.to_xml
            end
        end
    end
end
