#!/usr/bin/env ruby
require 'commander'
require 'mixml'

module Mixml
    # Mixml application class
    class Application
        include Commander::Methods

        # Command that selects nodes
        class SelectCommand < Commander::Command
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

                when_called self, :perform
            end

            # Run the command
            #
            # @param args [Array<String>] Arguments from the command line
            # @param options [Commander::Command::Options] Options from the command line
            def perform(args, options)
                $tool.work(args) do
                    @selectors.each do |selector|
                        selection = instance_eval(&selector)
                        selection.send name
                    end
                end
            end
        end

        # Command that selects and modifies nodes
        class ModifyCommand < SelectCommand
            # Initialize a new command
            #
            # @param method [Symbol] Command method
            # @param args [Array<String>] Command arguments
            def initialize(method, args = ARGV)
                super(method, args)

                @template = nil

                option '-s', '--string STRING', String, 'String value' do |value|
                    raise SystemExit, 'Value already specified. Please use --string or --template only once.' unless @template.nil?
                    @template = Mixml::Template::Text.new(value)
                end

                option '-t', '--template STRING', String, 'Template expression value' do |value|
                    raise SystemExit, 'Value already specified. Please use --string or --template only once.' unless @template.nil?
                    @template = Mixml::Template::Expression.new(value)
                end
            end

            def perform(args, options)
                raise SystemExit, 'Please specify a value with --string or --template.' if @template.nil?

                $tool.work(args) do
                    @selectors.each do |selector|
                        selection = instance_eval(&selector)
                        selection.send name, @template
                    end
                end
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

            command :pretty do |c|
                c.description = 'Pretty print XML files'
                c.action do |args, options|
                    $tool.pretty = true
                    $tool.work(args)
                end
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
