# mixml Values

This document demonstrates the different methods to specify values when using mixml.

## Strings

You can specify values with a string, e.g. the new node when replacing content. Ruby
[string interpolation][string interpolation] is performed on string values, so you can also use Ruby expressions
in string values.

[string interpolation]: http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals#Interpolation

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

You can then use the following mixml script in `test.mixml` to replace some nodes:

    xpath '//philosopher[@name="Hobbes"]' do
        replace '<tiger-and-#{node.name} name="Hobbes"/>'
    end

Now execute the following command to run the script:

    # mixml execute --script test.mixml test.xml

This produces the following XML output:

    <list>
        <tiger-and-philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

## Templates

You can also use a template to specify complex replacement. Mixml uses [Erubis][Erubis] as templating engine, and `{`
and `}` as delimiters.

[Erubis]: http://www.kuwata-lab.com/erubis

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

You can then use the following mixml script in `test.mixml` to replace some nodes:

    xpath '//philosopher' do
        replace template %{
            <{=node.name} name="{=node['name']}">
                {if node['name'] == "Hobbes"}
                    <hobby name="Space Travel"/>
                {else}
                    <hobby name="Philosophy"/>
                {end}
            </{=node.name}>
        }
    end

Now execute the following command to run the script:

    # mixml execute --script test.mixml test.xml

This produces the following XML output:

    <list>
        <philosopher name="Hobbes">
            <hobby name="Space Travel"/>
        </philosopher>
        <philosopher name="Rawls">
            <hobby name="Philosophy"/>
        </philosopher>
    </list>

### XML Builder

You can also use an XML builder to create values using the simple DSL provided by [Nokogiri][Nokogiri builder].

[Nokogiri builder]: http://nokogiri.org/Nokogiri/XML/Builder.html

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

You can then use the following mixml script in `test.mixml` to replace some nodes:

    xpath '//philosopher[@name="Hobbes"]' do
        replace xml ->(node, xml) {
            xml.tiger(:name => node['name']) {
                xml.hobby(:name => 'Space Travel')
            }
        }
    end

Now execute the following command to run the script:

    # mixml execute --script test.mixml test.xml

This produces the following XML output:

    <list>
        <tiger name="Hobbes">
            <hobby name="Space Travel"/>
        </tiger>
        <philosopher name="Rawls"/>
    </list>

### Plain Ruby

If you prefer, you can also use plain Ruby code to modify nodes.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

You can then use the following mixml script in `test.mixml` to rename some nodes:

    with_nodes xpath '//philosopher[@name="Hobbes"]' do |node|
        node.name = 'tiger'
    end

Now execute the following command to run the script:

    # mixml execute --script test.mixml test.xml

This produces the following XML output:

    <list>
        <tiger name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

Instead of processing each node individually, you can also process the selected node sets.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

You can then use the following mixml script in `test.mixml` to replace some nodes:

    with_nodesets xpath '//philosopher[@name="Hobbes"]' do |nodeset|
        nodeset.remove
    end

Now execute the following command to run the script:

    # mixml execute --script test.mixml test.xml

This produces the following XML output:

    <list>
        <philosopher name="Rawls"/>
    </list>
