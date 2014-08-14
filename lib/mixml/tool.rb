require 'mixml/selection'
require 'mixml/document'
require 'mixml/template/template'
require 'docile'
require 'nokogiri'

module Mixml
    class Tool
        attr_reader :documents
        attr_accessor :pretty
        attr_accessor :save
        attr_accessor :indent

        def initialize
            @indent = 4
            @pretty = false
            @save = false
            @documents = []
        end

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

        def save_all
            options = {}

            if @pretty then
                options[:indent] = @indent
            end

            @documents.each do |document|
                File.open(document.name, 'w') do |file|
                    document.xml.write_xml_to(file, options)
                end
            end
        end

        def print_all
            options = {}

            if @pretty then
                options[:indent] = @indent
            end

            @documents.each do |document|
                if @documents.size > 1 then
                    puts '-' * document.name.length
                    puts document.name
                    puts '-' * document.name.length
                end
                puts document.xml.to_xml(options)
            end
        end

        def remove_all
            @documents = []
        end

        def flush
            if @save then
                save_all
            else
                print_all
            end

            remove_all
        end

        def work(*file_names, &block)
            remove_all

            file_names.each do |file_name|
                load(file_name)
            end

            if not block.nil? then
                execute(&block)
            end

            flush
        end

        def process
            @documents.each do |document|
                yield document.xml
            end
        end

        def xpath(query, &block)
            process do |xml|
                nodes = xml.xpath(query)
                selection = Selection.new(nodes)

                if block_given? then
                    Docile.dsl_eval(selection, &block)
                end
            end
        end

        def template(text)
            Template::Template.new(text)
        end

        def execute(program = nil, &block)
            if not program.nil? then
                instance_eval(program)
            end

            if not block.nil? then
                Docile.dsl_eval(self, &block)
            end
        end
    end
end
