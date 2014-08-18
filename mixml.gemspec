# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'mixml/version'

Gem::Specification.new do |spec|
    spec.name = 'mixml'
    spec.version = Mixml::VERSION
    spec.authors = ['Jochen Seeber']
    spec.email = ['jochen@seeber.me']
    spec.summary = 'Easily manipulate multiple XML files at once'
    spec.description = 'Never use XSLT again...'
    spec.homepage = 'https://github.com/jochenseeber/mixml'
    spec.license = 'AGPL-3.0'
    spec.metadata = {
        'issue_tracker' => 'https://github.com/jochenseeber/mixml/issues',
        'source_code' => 'https://github.com/jochenseeber/mixml',
        'documentation' => 'http://rubydoc.info/gems/mixml/frames',
        'wiki' => 'https://github.com/jochenseeber/mixml/wiki'
    }

    spec.files = Dir['README.md', 'LICENSE.txt', '.yardopts', 'lib/**/*.rb', 'demo/**/*.{md,rb}']
    spec.executables = ['mixml']
    spec.require_paths = ['lib']

    spec.add_dependency 'commander', '~> 4.2'
    spec.add_dependency 'nokogiri', '~> 1.6'
    spec.add_dependency 'erubis', '~> 2.7'
    spec.add_dependency 'docile', '~> 1.1'

    spec.add_development_dependency 'bundler', '~> 1.6'
    spec.add_development_dependency 'rake', '~> 10.3'
    spec.add_development_dependency 'qed', '~> 2.9'
    spec.add_development_dependency 'rspec-expectations', '~> 3.0'
    spec.add_development_dependency 'rspec-collection_matchers', '~> 1.0'
    spec.add_development_dependency 'equivalent-xml', '~> 0.5'
    spec.add_development_dependency 'yard', '~> 0.8'
    spec.add_development_dependency 'coveralls', '~> 0.7'
end
