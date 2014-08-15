

module Mixml
    # Loaded XML document
    class Document
        # @return [String] Document name
        attr_reader :name

        # @return [String] XML document
        attr_reader :xml

        # @param name [String] Document name
        # @param xml [Nokigiri::XML::Document] XML document
        def initialize(name, xml)
            @name = name
            @xml = xml
        end
    end
end
