require 'mixml/template/base'
require 'erubis'

module Mixml
    # Module for template classes
    module Template
        # XML builder based template
        class Xml < Base
            # Initialize new XML template
            #
            # @param proc [lambda] Proc to create xml
            def initialize(proc)
                @proc = proc
            end

            # Evaluate the template
            #
            # @param [Nokogiri::XML::Node] node Current node
            # @return [String] Template result
            def evaluate(node)
                builder = Nokogiri::XML::Builder.new do |xml|
                    @proc.call(node, xml)
                end
                builder.to_xml
            end
        end
    end
end
