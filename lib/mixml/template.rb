require 'mixml/template/text'

# Extend String
class String
    # Convert a string into a template
    #
    # @return [Mixml::Template::Text] String as template
    def to_mixml_template
        ::Mixml::Template::Text.new(self)
    end
end
