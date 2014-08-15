module Mixml
    module Template
        # Base class for templates
        class Base
            # Convert into a template
            #
            # This is done by the complex and intricate process of returning `self`.
            #
            # @return [Mixml::Template::Base] Return self
            def to_mixml_template
                self
            end
        end
    end
end
