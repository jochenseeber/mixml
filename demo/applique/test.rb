require 'fileutils'
require 'rspec/expectations'
require 'rspec/collection_matchers'
require 'equivalent-xml'
require 'nokogiri'

include RSpec::Matchers

# File with test content
class TestFile
    include RSpec::Matchers

    # @return [String] File name
    attr_reader :file_name

    # @param file_name [String] File name
    def initialize(file_name)
        @file_name = file_name
    end

    # Write text into file
    #
    # @param text [String] Text to write
    # @return [void]
    def <<(text)
        File.open(@file_name, 'w') do |f|
            f.write text
        end
    end

    # Expect file to match content
    #
    # @param object [String, Nokogiri::XML::Document] Text or XML to match
    # @return [void]
    def matches(object)
        content = File.read(@file_name)
        if object.is_a?(Nokogiri::XML::Document) then
            expect(content).to be_equivalent_to(object)
        else
            expect(content).to be(object)
        end
    end
end

# Create a new test file
def file(name)
    FileUtils.mkpath(File.dirname(name))
    TestFile.new(name)
end

# Create a new XML document
def xml(text)
    Nokogiri::XML(text)
end

# Redirect stdout and return output
#
# @yield Execute block with redirected stdout
# @return [String] Output
def redirect
    begin
        old_stdout = $stdout
        $stdout = StringIO.new('', 'w')
        yield
        $stdout.string
    ensure
        $stdout = old_stdout
    end
end

# Define a new matcher to compare text files ignoring empty lines as well as leading and trailing spaces.
RSpec::Matchers.define :match_text do |expected|
    # Remove empty lines and leading and trailing spaces from text
    #
    # @param text [String] Text to clean
    # @return [String] cleaned text
    def clean(text)
        text.gsub(/\n+/, "\n").gsub(/^\s+|\s+$/, '')
    end

    match do |actual|
        clean(actual) == clean(expected)
    end
end
