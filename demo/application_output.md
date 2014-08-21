# mixml Output

This document demonstrates the different output options when using mixml.

## Print Modified Documents

Mixml prints the modified documents to the console per default.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

Now execute the following command to replace some nodes:

    # mixml rename --xpath '//philosopher[@name="Hobbes"]' --string 'tiger' test.xml

This produces the following XML output:

    <list>
        <tiger name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

## Print Headers When Processing Multiple Documents

Mixml also prints the file names of the documents if multiple documents are processed.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

Let's use the following XML in file `more.xml`:

    <list>
        <philosopher name="Kant"/>
        <philosopher name="Platon"/>
    </list>

Now execute the following command to remove some nodes:

    # mixml remove --xpath '//philosopher[@name="Kant"]' test.xml more.xml

This produces the following text output:

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
        <philosopher name="Platon"/>
    </list>

## Save Modified Documents

We can also save the modified files after changing them.

Let's use the following XML in file `test.xml`:

    <list>
        <philosopher name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

Now execute the following command to rename some nodes:

    # mixml rename --inplace --xpath '//philosopher[@name="Hobbes"]' --string 'tiger' test.xml

This produces the following XML in file `test.xml`:

    <list>
        <tiger name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>

## Pretty Print Output

You can also pretty print the output.

Let's use the following XML in file `test.xml`:

    <list><philosopher name="Hobbes"/><philosopher name="Rawls"/></list>

Now execute the following command to rename some nodes:

    # mixml rename --pretty --xpath '//philosopher[@name="Hobbes"]' --string 'tiger' test.xml

This produces the following text output:

    <?xml version="1.0"?>
    <list>
        <tiger name="Hobbes"/>
        <philosopher name="Rawls"/>
    </list>
