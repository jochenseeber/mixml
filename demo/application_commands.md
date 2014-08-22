# mixml Commands

This document demonstrates the different mixml commands to modify XML documents.

## Pretty print

You can use mixml to pretty print your XML documents.

Let's use the following XML in file `test.xml`:

    <list><philosopher name="Hobbes"/><philosopher name="Rawls"/></list>

Now execute the following command to pretty print this file:

    # mixml pretty test.xml

This produces the following text output:

    <?xml version="1.0"?>
    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

## Write nodes

You can use mixml to print selected nodes from your XML documents.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

Now execute the following command to select some nodes and remove them:

    # mixml write --quiet --xpath '//philosopher/@name' test.xml

This produces the following text output:

    name="Hobbes"
    name="Rawls"

You can also supply an expression that used to create the output:

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

Now execute the following command to select some nodes and remove them:

    # mixml write --quiet --xpath '//philosopher/@name' --template '{=node.name}={=node.value}' test.xml

This produces the following text output:

    name=Hobbes
    name=Rawls

## Remove nodes

You can use mixml to remove nodes from your XML documents.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

Now execute the following command to select some nodes and remove them:

    # mixml remove --xpath '//philosopher[@name="Hobbes"]' test.xml

This produces the following XML output:

    <list>
        <philosopher name="Rawls"/>
    </list>

## Replace nodes

You can use mixml to replace nodes in your XML documents.

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

## Append nodes

You can use mixml to append nodes to your XML documents.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

Now execute the following command to select some nodes and append a child node to them:

    # mixml append --xpath '/list' --string '<tiger name="Hobbes"/>' test.xml

This produces the following XML output:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
        <tiger name="Hobbes"/>
    </list>

## Replace attribute values

You can use mixml to replace attribute values in your XML documents.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

Now execute the following command to select some attributes and change their value:

    # mixml value --xpath '//philosopher[1]/@name' --string 'Platon' test.xml

This produces the following XML output:

    <list>
        <philosopher name="Platon"/>
        <philosopher name="Rawls"/>
    </list>

## Rename nodes

You can use mixml to rename nodes values in your XML documents.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

Now execute the following command to select some attributes and rename them:

    # mixml rename --xpath '//philosopher[@name="Hobbes"]' --template 'tiger-and-{=node.name}' test.xml

This produces the following XML output:

    <list>
        <tiger-and-philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>
