# mixml

[![Gem Version](https://badge.fury.io/rb/mixml.png)](http://badge.fury.io/rb/mixml)
[![Build Status](https://travis-ci.org/jochenseeber/mixml.png?branch=master)](https://travis-ci.org/jochenseeber/mixml)
[![Coverage Status](https://coveralls.io/repos/jochenseeber/mixml/badge.png?branch=master)](https://coveralls.io/r/jochenseeber/mixml?branch=master)
[![Inline docs](http://inch-ci.org/github/jochenseeber/mixml.png?branch=master)](http://inch-ci.org/github/jochenseeber/mixml)

Mixml is a small tool to greatly simplify the tedious task of changing multiple XML files at once. Its main purpose is
to spare me from having to use XSLT ever again.

## Usage

You can use mixml to change XML files in the following ways:

  * Pretty print
  * Print selected nodes and attributes to the console
  * Remove nodes
  * Add nodes
  * Replace nodes
  * Rename nodes
  * Change node values

For example, the following command will remove all attributes named `id` from the all XML files in the current
directory.

    mixml remove --inplace --xpath '//@id' *.xml

The following command will pretty print all XML files:

    mixml pretty --inplace *.xml

The following command will print all attribute names and values:

    mixml write --xpath '//@*' --template '{=node.name}={=node.value}' test.xml

You can find a description of all supported commands and usage examples [here](demo/application_commands.md).

## Selection

In addition to using XPath expressions, you can also use CSS rules to select the nodes you want to process. For
example, the following command will remove the first child of each element:

    mixml remove --inplace --css '*:first-child' *.xml

You can find a detailed description and usage examples [here](demo/application_selection.md).

## Scripts

In addition to the command line, mixml also supports a simple simple DSL to perform scripted changes. For example, to
perform the same as above using a script, save the following in `test.mixml`:

    xpath '//@id' do
        remove
    end

and then call:

    mixml execute --script test.mixml *.xml

You can also use mixml directly in your Ruby code. See [here](demo/application_invocation.md) for usage examples.

## Values

Mixml supports specifying XML fragments that are to be inserted using

  * [Ruby string interpolation](http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals#Interpolation)
  * [Erubis templates](http://www.kuwata-lab.com/erubis/)
  * [Nokogiri's XML DSL](http://nokogiri.org/Nokogiri/XML/Builder.html)
  * Plain Ruby

See [here](demo/application_values.md) for a description of all methods and detailed usage examples.

## Output

XML output can be printed to the console or written back to the file it was read from. Mixml also supports pretty
printing all output. See [here](demo/application_output.md) for a detailed description and usage examples.

## Installation

Install mixml:

    $ gem install mixml

## Contributing

1. Fork the GitHub repository: [https://github.com/jochenseeber/mixml/fork](https://github.com/jochenseeber/mixml/fork)
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create a new Pull Request
