require 'mixml'
require 'mixml/application'

def run_mixml_command(arguments)
    Commander::Runner.instance_variable_set :"@singleton", Commander::Runner.new(arguments)
    app = Mixml::Application.new
    app.run
end
