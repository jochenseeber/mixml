# mixml Selection

This document demonstrates the different methods to select XML nodes when using mixml.

## Select nodes using XPath expressions

You can use standard XPath expressions to select the nodes to process.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

Now execute the following command to rename some nodes:

    # mixml rename --xpath '//philosopher[@name="Hobbes"]' --string 'tiger' test.xml

This produces the following XML output:

    <list>
        <tiger name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

## Select nodes using CSS rules

You can also use CSS rules instead of XPath expressions to select the nodes to process.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

Now execute the following command to rename some nodes:

    # mixml rename --css 'philosopher:first-child' --string 'tiger' test.xml

This produces the following XML output:

    <list>
        <tiger name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>
