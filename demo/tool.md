# Tool usage

## Setup

First we need to create a new Tool object and load an XML file.

    require 'mixml'

    def testfile(name)
        File.join(File.dirname(__FILE__), name)
    end

    def prepare_tool(*files)
        tool = Mixml::Tool.new
        tool.pretty = true
        files.each do |file|
            tool.load(testfile(file))
        end
        tool
    end

## Remove nodes

Select some nodes with an XPath expression and then remove them

    prepare_tool('tool-1.xml').execute do
        xpath '//philosopher' do
            remove
        end
        print_all
    end

## Replace nodes with text

Select some elements with an XPath expression and then change the element name.

    prepare_tool('tool-1.xml').execute do
        xpath '//philosopher[@name = "Hobbes"]' do
            replace '<tiger name="Hobbes"/>'
        end
        print_all
    end

## Replace nodes with a template

Select some elements with an XPath expression and then change the element name.

    prepare_tool('tool-1.xml').execute do
        xpath '//philosopher[@name = "Hobbes"]' do
            replace template '<tiger name="{=node["name"]}"/>'
        end
        print_all
    end


## Replace attribute values with text

Select some attributes with an XPath expression and change their value.

    prepare_tool('tool-1.xml').execute do
        xpath '//philosopher[1]/@name' do
            value 'Thomas Hobbes'
        end
        print_all
    end

## Replace attribute values with a template

Select some attributes with an XPath expression and change their value using a template-

    prepare_tool('tool-1.xml').execute do
        xpath '//philosopher[2]/@name' do
            value template 'John {=node.value}'
        end
        print_all
    end

## Evaluate a command string

Evaluate a command string with mixml commands

    prepare_tool('tool-1.xml').execute("xpath('//philosopher') { remove }")

## Do everything in one step

Load files, modify them and optionally save them again in one step using the `work` method.

    tool = Mixml::Tool.new
    tool.pretty = true
    tool.work(testfile('tool-1.xml')) do
        xpath '//philosopher' do
            remove
        end
    end

## Save modified documents

Load files, modify them and optionally save them again in one step using the `work` method.

    require 'tempfile'

    tool = Mixml::Tool.new
    tool.pretty = true
    tool.save = true
    file = Tempfile.new(['doc', '.xml'])
    begin
        FileUtils.cp(testfile('tool-1.xml'), file.path)
        file.close
        tool.work(file.path) do
            xpath '//philosopher' do
                remove
            end
        end
    rescue
        file.close!
    end

## Print headers when procsessing multiple documents

    tool = prepare_tool('tool-1.xml', 'tool-2.xml')
    tool.pretty = true
    tool.print_all
