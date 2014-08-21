require 'fileutils'
require 'equivalent-xml'
require 'nokogiri'
require 'ae'
require 'mixml'
require 'mixml/application'

# Add bin directory to path
ENV['PATH'] = File.join(QED::Utils.root, 'bin') + ":" + ENV['PATH']

# Redirect stdout and return output
#
# @yield Execute block with redirected stdout
# @return [String] Output
def redirect
    begin
        old_stdout = $stdout
        old_stderr = $stderr
        $stdout = StringIO.new('', 'w')
        $stderr = $stdout
        yield
        $stdout.string
    ensure
        $stdout = old_stdout
        $stderr = old_stderr
    end
end

# Remove empty lines and leading and trailing spaces from text
#
# @param text [String] Text to clean
# @return [String] cleaned text
def clean(text)
    raise(ArgumentError, 'Text must not be nil.') if text.nil?

    text.gsub(/\n+/, "\n").gsub(/^\s+|\s+$/, '')
end

When /\buse\b[^.]+\bXML in (?:file )?`([a-z]+\.xml)`/i do |file_name, xml|
    raise(ArgumentError, 'Please supply a block with the XML document') if xml.nil?

    doc = Nokogiri::XML(xml) do |config|
        config.default_xml.noblanks
    end

    File.open(file_name, 'w') do |f|
        doc.write_xml_to(f, :indent => 4)
    end
end

When /\buse\b[^.]+\bscript in (?:file )?`([a-z]+\.mixml)`/i do |file_name, text|
    raise(ArgumentError, 'Please supply a block with the mixml script') if text.nil?

    File.open(file_name, 'w') do |f|
        f.write(text)
    end
end

When /\bproduces\b[^.]+\bXML in (?:file )?`([a-z]+\.xml)`/i do |file_name, xml|
    raise(ArgumentError, 'Please supply a block with the XML document') if xml.nil?

    actual = Nokogiri::XML(File.read('test.xml')) do |config|
        config.default_xml.noblanks
    end

    expected = Nokogiri::XML(xml) do |config|
        config.default_xml.noblanks
    end

    EquivalentXml.assert.equivalent?(actual, expected, :element_order => true)
end

When /\bproduces\b[^.]+\bXML output\b/i do |xml|
    raise(ArgumentError, 'Please supply a block with the XML document') if xml.nil?

    actual = Nokogiri::XML(@output) do |config|
        config.default_xml.noblanks
    end

    expected = Nokogiri::XML(xml) do |config|
        config.default_xml.noblanks
    end

    options = {:element_order => true}
    EquivalentXml.assert.equivalent?(actual, expected, options)
end

When /\bproduces\b[^.]+\btext output\b/i do |text|
    raise(ArgumentError, 'Please supply a block with the text') if text.nil?
    clean(@output).assert == clean(text)
end

When /\bexecute\b[^.]+\bcommand\b/i do |command|
    raise(ArgumentError, 'Please supply a block with the command to run') if command.nil?
    command.gsub!(/^#\s*/, '')
    arguments = Shellwords.shellsplit(command)
    Commander::Runner.instance_variable_set :"@singleton", Commander::Runner.new(arguments[1..-1])
    app = Mixml::Application.new

    @output = redirect do
        app.run
    end
end

When /\bexecuting\b[^.]+\bfails\b/i do |command|
    raise(ArgumentError, 'Please supply a block with the command to run') if command.nil?
    command.gsub!(/^#\s*/, '')
    arguments = Shellwords.shellsplit(command)
    Commander::Runner.instance_variable_set :"@singleton", Commander::Runner.new(arguments[1..-1])
    app = Mixml::Application.new
    app.run

    SystemExit.expect do
        @output = redirect do
            app.run
        end
    end
end
