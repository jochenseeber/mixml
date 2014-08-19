require 'mixml'
require 'mixml/template'

module Mixml
    # Selection of XML nodes
    class Selection
        # @return [Nokogiri::XML::NodeSet] Selected nodes
        attr_reader :nodesets

        # @param nodesets [Array<Nokogiri::XML::NodeSet>] Selected nodes
        def initialize(nodesets)
            @nodesets = nodesets
        end

        # Remove selected nodes from the document
        def remove
            each_node do |nodeset|
                nodeset.remove
            end
        end

        # Replace selected nodes with a template
        #
        # @param template [Template::Base] Template to replace nodes with
        def replace(template)
            template = template.to_mixml_template

            each_node do |node|
                value = template.evaluate(node)
                node.replace(value)
            end
        end

        # Append children to node
        #
        # @param template [Template::Base] Template to replace nodes with
        def append(template)
            template = template.to_mixml_template

            each_node do |node|
                value = template.evaluate(node)
                node << value
            end
        end

        # Set the value selected nodes with a template
        #
        # @param template [Template::Base] Template to set the value
        def value(template)
            template = template.to_mixml_template

            each_node do |node|
                value = template.evaluate(node)
                node.value = value
            end
        end

        # Rename selected nodes with a template
        #
        # @param template [Template::Base] Template for new name
        def rename(template)
            template = template.to_mixml_template

            each_node do |node|
                value = template.evaluate(node)
                node.name = value
            end
        end

        protected

        # Execute a block for each node
        #
        # @yield Block to execute for each node
        # @yieldparam node [Nokogiri::XML::Node] Current node
        def each_node
            @nodesets.each do |nodeset|
                nodeset.each do |node|
                    yield node
                end
            end
        end
    end
end
