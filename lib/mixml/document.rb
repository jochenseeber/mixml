

module Mixml
    class Document
        attr_reader :name
        attr_reader :xml

        def initialize(name, xml)
            @name = name
            @xml = xml
        end
    end
end
