#!/usr/bin/env ruby
require 'commander'
require 'mixml'

module Mixml
    # Mixml application class
    class Application
        include Commander::Methods

        # Command that selects nodes
        class SelectCommand < Commander::Command
            # @return [Boolean] Suppress automatic output of result
            attr_accessor :suppress_output

            # Initialize a new command
            #
            # @param method [Symbol] Command method
            # @param args [Array<String>] Command arguments
            def initialize(method, args = ARGV)
                super(method)

                @method = method
                @selectors = []

                option '-x', '--xpath STRING', String, 'XPath expression to select nodes' do |value|
                    @selectors << ->(tool) {
                        xpath value
                    }
                end

                option '-c', '--css STRING', String, 'CSS rule to select nodes' do |value|
                    @selectors << ->(tool) {
                        css value
                    }
                end

                when_called self, :execute
            end

            # Run the command
            #
            # @param args [Array<String>] Arguments from the command line
            # @param options [Commander::Command::Options] Options from the command line
            def execute(args, options)
                before args, options

                if @suppress_output then
                    $tool.print = false
                    $tool.save = false
                end

                $tool.work(args) do
                    @selectors.each do |selector|
                        selection = instance_eval(&selector)
                        selection.send name, *parameters
                    end
                end
            end

            # Parameters for command execution
            #
            # @return [Array] Parameters
            def parameters
                []
            end

            # Invoked before the command is executed
            #
            # @param args [Array<String>] Arguments from the command line
            # @param options [Commander::Command::Options] Options from the command line
            def before(args, options)
                if @selectors.empty? then
                    raise SystemExit, 'Please specify the nodes to process with --xpath or --css.'
                end
            end
        end

        # Command that selects and modifies nodes
        class ModifyCommand < SelectCommand
            # @return [Boolean] Supplying an expression is optional
            attr_accessor :optional_expression

            # Initialize a new command
            #
            # @param method [Symbol] Command method
            # @param args [Array<String>] Command arguments
            def initialize(method, args = ARGV)
                super(method, args)

                @template = nil
                @optional_expression = false

                option '-s', '--string STRING', String, 'String value' do |value|
                    raise SystemExit, 'Value already specified. Please use --string or --template only once.' unless @template.nil?
                    @template = Mixml::Template::Text.new(value)
                end

                option '-t', '--template STRING', String, 'Template expression value' do |value|
                    raise SystemExit, 'Value already specified. Please use --string or --template only once.' unless @template.nil?
                    @template = Mixml::Template::Expression.new(value)
                end
            end

            # Check if an expression is set
            def before(args, options)
                super(args, options)
                
                if not @optional_expression and @template.nil? then
                    raise SystemExit, 'Please specify a value with --string or --template.'
                end
            end

            # Return the template as parameter
            def parameters
                [@template]
            end
        end

        # Create a new selection command
        #
        # @param name [Symbol] command name
        def select_command(name)
            c = add_command SelectCommand.new(name)
            yield c if block_given?
        end

        # Create a new modification command
        #
        # @param name [Symbol] command name
        def modify_command(name)
            c = add_command ModifyCommand.new(name)
            yield c if block_given?
        end

        # Run the mixml command
        def run
            program :name, 'mixml'
            program :version, Mixml::VERSION
            program :description, 'XML helper tool'

            $tool = Mixml::Tool.new

            global_option('-p', '--pretty', 'Pretty print output') do |value|
                $tool.pretty = value
            end

            global_option('-i', '--inplace', 'Replace the processed files with the new files') do |value|
                $tool.save = value
                $tool.print = !value
            end

            global_option('-q', '--quiet', 'Do not print nodes') do |value|
                $tool.print = !value
            end

            command :pretty do |c|
                c.description = 'Pretty print XML files'
                c.action do |args, options|
                    $tool.pretty = true
                    $tool.work(args)
                end
            end

            modify_command :write do |c|
                c.description = 'Write selected nodes to the console'
                c.suppress_output = true
                c.optional_expression = true
            end

            select_command :remove do |c|
                c.description = 'Remove nodes from the XML documents'
            end

            modify_command :replace do |c|
                c.description = 'Replace nodes in the XML documents'
            end

            modify_command :append do |c|
                c.description = 'Append child nodes in the XML documents'
            end

            modify_command :rename do |c|
                c.description = 'Rename nodes in the XML documents'
            end

            modify_command :value do |c|
                c.description = 'Set node values'
            end

            command :execute do |c|
                c.description = 'Execute script on the XML documents'
                c.option '-s', '--script STRING', String, 'Script file to execute'
                c.option '-e', '--expression STRING', String, 'Command to execute'
                c.action do |args, options|
                    script = options.expression || File.read(options.script)

                    $tool.work(args) do
                        execute(script)
                    end
                end
            end

            run!
        end
    end
end
