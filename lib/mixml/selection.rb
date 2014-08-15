require 'mixml'
require 'mixml/template'

module Mixml
    # Selection of XML nodes
    class Selection
        # @return [Nokogiri::XML::NodeSet] Selected nodes
        attr_reader :nodes

        # @param nodes [Nokogiri::XML::NodeSet] Selected nodes
        def initialize(nodes)
            @nodes = nodes
        end

        # Remove selected nodes from the document
        def remove
            @nodes.remove
        end

        # Replace selected nodes with a template
        #
        # @param template [Template::Base] Template to replace nodes with
        def replace(template)
            template = template.to_mixml_template

            @nodes.each do |node|
                value = template.evaluate(node)
                node.replace(value)
            end
        end

        # Set the value selected nodes with a template
        #
        # @param template [Template::Base] Template to set the value
        def value(template)
            template = template.to_mixml_template

            @nodes.each do |node|
                value = template.evaluate(node)
                node.value = value
            end
        end

        # Rename selected nodes with a template
        #
        # @param template [Template::Base] Template for new name
        def rename(template)
            template = template.to_mixml_template

            @nodes.each do |node|
                value = template.evaluate(node)
                node.name = value
            end
        end
    end
end
