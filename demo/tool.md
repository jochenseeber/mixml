# Usage examples

## Setup

First we need to create a new Tool object and load an XML file. We create a Mixml tool object and use a
[helper](applique/test.rb) to load the following XML for each example.

    require 'mixml'

    Before do
        @tool = Mixml::Tool.new do |t|
            # Pretty print output
            t.pretty = true

            # Save output after processing
            t.save = true

            # Don't print documents after processing
            t.print = false
        end

        # Save test.xml
        file('test.xml') << %{
            <list>
                <philosopher name="Hobbes"/>
                <philosopher name="Rawls"/>
            </list>
        }

        @tool.load('test.xml')
    end

## Remove nodes

Select some nodes with an XPath expression and then remove them

    @tool.execute do
        xpath '//philosopher' do
            remove
        end
    end
    @tool.flush

    file('test.xml').matches xml %{
        <list/>
    }

## Replace nodes

Select some elements with an XPath expression and then change the element name.

    @tool.execute do
        xpath '//*[@name = "Hobbes"]' do
            replace '<tiger name="Hobbes"/>'
        end
    end
    @tool.flush

    file('test.xml').matches xml %{
        <list>
            <tiger name="Hobbes"/>
            <philosopher name="Rawls"/>
        </list>
    }

## Replace nodes with string interpolation

Ruby [string interpolation](http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals#Interpolation) is performed on
string parameters, so you can also select some elements with an XPath expression and then change each element using a
Ruby expression.

    @tool.execute do
        xpath '//*[@name = "Hobbes"]' do
            replace '<tiger-and-#{node.name} name="Hobbes"/>'
        end
    end
    @tool.flush

    file('test.xml').matches xml %{
        <list>
            <tiger-and-philosopher name="Hobbes"/>
            <philosopher name="Rawls"/>
        </list>
    }

This works for all commands that take a string parameter.

## Replace nodes with a template

If you prefer, you can also use template expressions instead of string parameters. Mixml uses
[Erubis](http://www.kuwata-lab.com/erubis) as templating engine, and `{` and `}` as delimiters. With this, you can
select some elements with an XPath expression and then replace each element.

    @tool.execute do
        xpath '//*[@name = "Hobbes"]' do
            replace template '<tiger-and-{=node.name} name="{=node["name"]}"/>'
        end
    end
    @tool.flush

    file('test.xml').matches xml %{
        <list>
            <tiger-and-philosopher name="Hobbes"/>
            <philosopher name="Rawls"/>
        </list>
    }

This works for all commands that take a string parameter.

## Replace nodes with XML

If you prefer, you can also use an XML builder to create values using the simple DSL provided by
[Nokogiri](http://nokogiri.org/Nokogiri/XML/Builder.html). Using this, you can select some elements with an XPath
expression and then replace each element.

    @tool.execute do
        xpath '//*[@name = "Hobbes"]' do
            replace xml do |node, xml|
                xml.send(:"tiger-and-philosopher", :name => node['name'])
            end
        end
    end
    @tool.flush

    file('test.xml').matches xml %{
        <list>
            <tiger-and-philosopher name="Hobbes"/>
            <philosopher name="Rawls"/>
        </list>
    }

This works for all commands that take XML text as parameter (e.g. replace and append).

## Append nodes

Select some elements with an XPath expression and then append children to them.

    @tool.execute do
        xpath '/list' do
            append '<tiger name="Hobbes"/>'
        end
    end
    @tool.flush

    file('test.xml').matches xml %{
        <list>
            <philosopher name="Hobbes"/>
            <philosopher name="Rawls"/>
            <tiger name="Hobbes"/>
        </list>
    }

## Replace attribute values

Select some attributes with an XPath expression and change their value.

    @tool.execute do
        xpath '//philosopher[1]/@name' do
            value 'Thomas Hobbes'
        end
    end
    @tool.flush

    file('test.xml').matches xml %{
        <list>
            <philosopher name="Thomas Hobbes"/>
            <philosopher name="Rawls"/>
        </list>
    }

## Rename nodes

Select some nodes with an XPath expression and change their name.

    @tool.execute do
        xpath '//philosopher[@name = "Hobbes"]' do
            rename 'tiger-and-#{node.name}'
        end
    end
    @tool.flush

    file('test.xml').matches xml %{
        <list>
            <tiger-and-philosopher name="Hobbes"/>
            <philosopher name="Rawls"/>
        </list>
    }

## Evaluate a command string

Evaluate a command string with mixml commands

    @tool.execute("xpath('//philosopher') { remove }")
    @tool.flush

    file('test.xml').matches xml %{
        <list/>
    }

## Select nodes using CSS rules

You can also use CSS rules to select the nodes to process

    @tool.execute("css('philosopher:first-child') { remove }")
    @tool.flush

    file('test.xml').matches xml %{
        <list>
            <philosopher name="Rawls"/>
        </list>
    }

## Do everything in one step

Load files, modify them and optionally save them again in one step using the `work` method.

    tool = Mixml::Tool.new do |t|
        t.pretty = true
    end

    @tool.work('test.xml') do
        xpath '//philosopher' do
            remove
        end
    end

    expect(@tool.documents).to have(0).items

    file('test.xml').matches xml %{
        <list/>
    }

## Print modified documents without saving

Print files whithout saving them.

    @tool.save = false
    @tool.print = true

    @tool.execute do
        xpath '//philosopher' do
            remove
        end
    end

    @tool.flush

    # Check if file still is unmodified
    file('test.xml').matches xml %{
        <list>
            <philosopher name="Hobbes"/>
            <philosopher name="Rawls"/>
        </list>
    }

## Print headers when processing multiple documents

    text = redirect do
        file('more.xml') << %{
            <list>
                <philosopher name="Kant"/>
                <philosopher name="Platon"/>
            </list>
        }

        @tool.load('more.xml')
        @tool.print_all
    end

    expect(text).to match_text(%{
        --------
        test.xml
        --------
        <?xml version="1.0"?>
        <list>
            <philosopher name="Hobbes"/>
            <philosopher name="Rawls"/>
        </list>
        --------
        more.xml
        --------
        <?xml version="1.0"?>
        <list>
            <philosopher name="Kant"/>
            <philosopher name="Platon"/>
        </list>
    })
