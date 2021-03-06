require 'mixml/selection'
require 'mixml/document'
require 'mixml/template/expression'
require 'mixml/template/xml'
require 'mixml/template/text'
require 'docile'
require 'nokogiri'

# Mixml main module
module Mixml
    # Mixml tool
    #
    # This is the main class for using mixml.
    class Tool
        # @return [Array<Document>] loaded XML Documents
        attr_reader :documents

        # @return [Boolean] pretty print XML during output
        attr_accessor :pretty

        # @return [Boolean] save processed XML documents, defaults to false
        attr_accessor :save

        # @return [Boolean] print processed XML documents, defaults to true
        attr_accessor :print

        # @return [Integer] indent width, defaults to 4
        attr_accessor :indent

        # Intialize a new mixml tool
        def initialize
            @indent = 4
            @pretty = false
            @save = false
            @print = true
            @documents = []
        end

        # Load XML files
        #
        # @param file_names [Array] Names of the XML files to load
        # @return [void]
        def load(*file_names)
            file_names.flatten.each do |file_name|
                xml = File.open(file_name, 'r') do |file|
                    Nokogiri::XML(file) do |config|
                        if @pretty then
                            config.default_xml.noblanks
                        end
                    end
                end
                @documents << Document.new(file_name, xml)
            end
        end

        # Output all loaded XML files
        #
        # @yield Block to write each document
        # @yieldparam document [Document] Document to write
        def output_all
            options = {}

            if @pretty then
                options[:indent] = @indent
            end

            @documents.each do |document|
                yield document, options
            end
        end

        # Save all loaded XML files
        #
        # Pretty prints the XML if {#pretty} is enabled.
        #
        # @return [void]
        def save_all
            output_all do |document, options|
                File.open(document.name, 'w') do |file|
                    document.xml.write_xml_to(file, options)
                end
            end
        end

        # Print all loaded XML files
        #
        # Pretty prints the XML if {#pretty} is enabled. If more than one file is loaded, a header with the file's name
        # is printed before each file.
        #
        # @return [void]
        def print_all
            output_all do |document, options|
                if @documents.size > 1 then
                    puts '-' * document.name.length
                    puts document.name
                    puts '-' * document.name.length
                end
                puts document.xml.to_xml(options)
            end
        end

        # Remove all loaded XML files
        #
        # Files are not saved before removing them.
        #
        # @return [void]
        def remove_all
            @documents = []
        end

        # Print/save all loaded XML files and then remove them
        #
        # Files are saved if {#save} is enabled, and they are printed to the console if {#print} is enabled.
        #
        # @return [void]
        def flush
            if @print then
                print_all
            end

            if @save then
                save_all
            end

            remove_all
        end

        # Perform work on a list of XML files
        #
        # Perform the following steps:
        # #. Remove all loaded XML files without saving them
        # #. Load the supplied XML files
        # #. Execute the supplied block
        # #. Flush all XML files
        #
        # @param file_names [Array] Names of the XML files to load
        # @yield Block to execute with loaded XML files
        # @return [void]
        def work(*file_names, &block)
            remove_all

            file_names.each do |file_name|
                load(file_name)

                if not block.nil? then
                    execute(&block)
                end

                flush
                remove_all
            end
        end

        # Execute a block for each loaded XML document
        #
        # @yield Block to execute for each XML document
        # @yieldparam xml {Nokogiri::XML::Document} XML document
        # @return [void]
        def process
            @documents.each do |document|
                yield document.xml
            end
        end

        # Select nodes using an XPath expression and execute DSL commands for these nodes
        #
        # @param paths [Array<String>] XPath expression
        # @yield Block to execute for each nodeset
        # @return [void]
        def xpath(*paths, &block)
            nodesets = []
            process do |xml|
                nodesets << xml.xpath(*paths)
            end
            selection = Selection.new(nodesets)

            if block_given? then
                Docile.dsl_eval(selection, &block)
            end

            selection
        end

        # Select nodes using CSS selectors and execute DSL commands for these nodes
        #
        # @param selectors [Array<String>] CSS selectors
        # @yield Block to execute for each nodeset
        # @return [void]
        def css(*selectors, &block)
            nodesets = []
            process do |xml|
                nodesets << xml.css(*selectors)
            end
            selection = Selection.new(nodesets)

            if block_given? then
                Docile.dsl_eval(selection, &block)
            end

            selection
        end

        # Create a DSL replacement template
        #
        # @param text [String] Template text
        # @return [Template] Replacement template
        def template(text)
            Template::Expression.new(text)
        end

        # Create a XML replacement template
        #
        # @return [Template] Replacement template
        # @param proc [Proc] Lambda to create XML
        def xml(proc)
            Template::Xml.new(proc)
        end

        # Execute a script or a block
        #
        # @param program [String] DSL script to execute
        # @yield Block to execute
        # @return [void]
        def execute(program = nil, &block)
            if not program.nil? then
                instance_eval(program)
            end

            if not block.nil? then
                Docile.dsl_eval(self, &block)
            end
        end

        # Execute block for each node
        #
        # @param selection [Selection] Selected nodes
        # @yield Block to execute for each node
        # @yieldparam node [Nokogiri::XML::Node] Current node
        def with_nodes(selection)
            selection.nodesets.each do |nodeset|
                nodeset.each do |node|
                    yield node
                end
            end
        end

        # Execute block for each node set
        #
        # @param selection [Selection] Selected nodes
        # @yield Block to execute for each node set
        # @yieldparam node [Nokogiri::XML::NodeSet] Current node set
        def with_nodesets(selection, &block)
            selection.nodesets.each do |nodeset|
                yield nodeset
            end
        end

    end
end
