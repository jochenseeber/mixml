# mixml Invocation

This document demonstrates the different methods to use mixml.

## Command Line

For simple tasks, you can specify the mixml command in the command line.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

Now execute the following command to select some nodes and replace them:

    # mixml replace --xpath '//philosopher[@name="Hobbes"]' --string '<tiger name="Hobbes"/>' test.xml

This produces the following XML output:

    <list>
        <tiger name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

## Script files

In addition to specifying what to do in the command line, you can also run scripts written in a simple DSL.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

You can then use the following mixml script in `test.mixml` to select all philosopher nodes with name 'Hobbes' and replace
them, and to delete all remaining philosopher nodes:

    xpath '//philosopher[@name="Hobbes"]' do
        replace template '<tiger-and-{=node.name} name="Hobbes"/>'
    end
    css 'philosopher' do
        remove
    end

Now execute the following command to execute the script:

    # mixml execute --script test.mixml test.xml

This produces the following XML output:

    <list>
        <tiger-and-philosopher name="Hobbes"/>
    </list>

## Script commands

You can also specify mixml script expressions directly on the command line without using a script file.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

Now execute the following command to select some nodes and replace them:

    # mixml execute --expression "xpath('//philosopher[@name=\"Hobbes\"]') { replace '<tiger name=\"Hobbes\"/>' }" test.xml

This produces the following XML output:

    <list>
        <tiger name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

## Ruby Code

You can also use mixml directly from your Ruby code.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

Just create a tool object, and let it execute a mixml script.

    tool = Mixml::Tool.new
    tool.pretty = true

    # Redirect stdout
    redirect do
        # Here comes the actual example
        tool.work('test.xml') do
            xpath '//philosopher[@name="Hobbes"]' do
                rename 'tiger'
            end
        end
    end

This produces the following XML output:

    <list>
        <tiger name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>
