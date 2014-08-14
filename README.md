# mixml

Mixml is a small tool to greatly simplify the tedious task of changing multiple multiple XML files at once. You can use
it to remove or replace elements and attributes or pretty print XML.

For example, the following command will remove all attributes named `id` from the supplied XML files:

    mixml remove --inplace --xpath '//@id' *.xml

Mixml also supports a simple DSL to perform scripted changes. To perform the same as above using a script, save the
following in `test.mixml`:

    xpath '//@id' do
        remove
    end

and then call:

    mixml execute --script test.mixml *.xml

## Installation

Install mixml:

    $ gem install mixml

## Usage

Use the following command to get help:

    mixml --help

### Pretty print XML

    mixml pretty *.xml

### Remove nodes

    mixml remove --xpath '//element' *.xml

### Replace nodes

    mixml replace --xpath '//element' --template '<other/>' *.xml

### Set node value

    mixml value --xpath '//element/@attr' --template 'value' *.xml

### Execute a script

Example script in `test.mixml`

    xpath '//element' do
        remove
    end
    xpath '//other' do
        replace template '<other-{=node.name}/>'
    end

Use the following command to run the script

    mixml execute --script test.mixml *.xml

Script commands:

    xpath 'xpath-expression' do
        remove # Remove node
        replace 'text' # Replace node with text
        replace template '{=rubyexpression}' # Replace node with a template. Variable node contains the current node.
        value 'text'
        value template '{=rubyexpression}' # Replace node with a template. Variable node contains the current node.
    end

We use [Erubis](http://www.kuwata-lab.com/erubis) as templating engine, and `{` and `}` as delimiters.

### Evaluate an expression

You can also pass the script to execute directly to mixml:

    mixml execute --expression 'xpath("//element") { remove }' *.xml

### Write results

The standard setting is to leave the input files unchanged and print the resulting files. You can replace the input
files with the changed XML by using the `incplace` option:

    mixml remove --inplace --xpath '//group' test.xml

This will remove all elements named `group` from `test.xml`.

### Pretty print results

To pretty print the output, use the `pretty` option:

    mixml remove --inplace --xpath '//group' --pretty test.xml

## Contributing

1. Fork it ( https://github.com/jochenseeber/mixml/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
