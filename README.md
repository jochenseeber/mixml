# mixml

[![Gem Version](https://badge.fury.io/rb/mixml.png)](http://badge.fury.io/rb/mixml)
[![Build Status](https://travis-ci.org/jochenseeber/mixml.png?branch=master)](https://travis-ci.org/jochenseeber/mixml)
[![Coverage Status](https://coveralls.io/repos/jochenseeber/mixml/badge.png?branch=master)](https://coveralls.io/r/jochenseeber/mixml?branch=master)

Mixml is a small tool to greatly simplify the tedious task of changing multiple multiple XML files at once. Its main
purpose is to spare me from having to use XSLT ever again. You can use mixml to change XML files in the following ways:

  * Pretty print
  * Remove nodes
  * Add nodes
  * Replace nodes
  * Rename nodes
  * Change node values

For example, the following command will remove all attributes named `id` from the supplied XML files:

    mixml remove --inplace --xpath '//@id' *.xml

Mixml also supports a simple DSL to perform scripted changes. To perform the same as above using a script, save the
following in `test.mixml`:

    xpath '//@id' do
        remove
    end

and then call:

    mixml execute --script test.mixml *.xml

You can also use mixml directly in your Ruby code:

    require 'mixml'

    tool = Mixml::Tool.new do |t|
        t.save = true
    end

    tool.work('one.xml', 'two.xml') do
        xpath '//@id' do
            remove
        end
    end

Mixml supports building replacement values using

  * [Ruby string interpolation](http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals#Interpolation)
  * [Erubis templates](http://www.kuwata-lab.com/erubis/)
  * [Nokogiri's XML DSL](http://nokogiri.org/Nokogiri/XML/Builder.html)
  * Plain Ruby

You can find more usage examples [here](demo/tool.md).

## Installation

Install mixml:

    $ gem install mixml

## Usage

Use the following command to get help:

    mixml --help

### Pretty print XML

    mixml pretty *.xml

### Remove nodes

    mixml remove --xpath '//addresses' *.xml

### Rename nodes

    mixml rename --xpath '//addresses' --template 'addressbook' *.xml

### Replace nodes

    mixml replace --xpath '//addresses' --template '<addressbook/>' *.xml

### Append nodes

    mixml append --xpath '/list' --template '<addressbook/>' *.xml

### Set node value

    mixml value --xpath '//addresses/@name' --template 'default' *.xml

### Execute a script

Example script in `test.mixml`

    xpath '//addresses[name="default"]' do
        remove
    end
    xpath '//addresses' do
        replace template '<addressbook/>'
    end

Use the following command to run the script

    mixml execute --script test.mixml *.xml

Script commands:

    xpath 'xpath-expression' do
        remove # Remove node
        replace 'xml' # Replace node
        append 'xml'
        value 'text' # Set node value
        rename 'text' # Rename node
    end

Instead of using strings for parameters, you can also use a template expression:

    xpath 'xpath-expression' do
        replace template 'special-{=node.name}' # Prefix nodes with 'special-''
    end

This works for all commands that take a string parameter. We use [Erubis](http://www.kuwata-lab.com/erubis) as
templating engine, and `{` and `}` as delimiters.

In addition, you can also use [Nokogiri](http://http://nokogiri.org/)'s
[builder component](http://nokogiri.org/Nokogiri/XML/Builder.html) to create the XML that replaces an element:

    xpath '//addresses' do
        replace xml do |node, xml|
            xml.addressbook(:name => node['name'])
        end
    end

### Use CSS rules to select nodes

You can also use CSS rules instead of XPath expressions to select the nodes to process:

    css 'addresses:first-child', 'addresses:last-child' do
        remove
    end

### Evaluate an expression

You can also pass the script to execute directly to mixml:

    mixml execute --expression 'xpath("//addresses") { remove }' *.xml

### Write results

The standard setting is to leave the input files unchanged and print the resulting files. You can replace the input
files with the changed XML by using the `inplace` option:

    mixml remove --inplace --xpath '//addresses' test.xml

This will remove all elements named `group` from `test.xml`.

### Pretty print results

To pretty print the output, use the `pretty` option:

    mixml remove --inplace --xpath '//addresses' --pretty test.xml

## Contributing

1. Fork the GitHub repository: [https://github.com/jochenseeber/mixml/fork](https://github.com/jochenseeber/mixml/fork)
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create a new Pull Request
