require 'mixml/template/text'

module Mixml
    class Selection
        attr_reader :nodes

        def initialize(nodes)
            @nodes = nodes
        end

        def remove
            @nodes.remove
        end

        def replace(template)
            if template.is_a?(String) then
                template = Template::Text.new(template)
            end

            @nodes.each do |node|
                value = template.evaluate(node)
                node.replace(value)
            end
        end

        def value(template)
            if template.is_a?(String) then
                template = Template::Text.new(template)
            end

            @nodes.each do |node|
                value = template.evaluate(node)
                node.value = value
            end
        end
    end
end
