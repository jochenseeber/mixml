# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mixml/version'

Gem::Specification.new do |spec|
    spec.name = 'mixml'
    spec.version = Mixml::VERSION
    spec.authors = ['Jochen Seeber']
    spec.email = ['jochen@seeber.me']
    spec.summary = 'XML tool to easily manipulate multiple XML files at once'
    spec.description = 'XML tool to easily manipulate multiple XML files at once'
    spec.homepage = 'https://github.com/jochenseeber/mixml'
    spec.license = 'AGPL-3.0'
    spec.metadata = {
        'issue_tracker' => 'https://github.com/jochenseeber/mixml/issues',
        'source_code' => 'https://github.com/jochenseeber/mixml',
        'documentation' => 'https://github.com/jochenseeber/mixml',
        'wiki' => 'https://github.com/jochenseeber/mixml/wiki'
    }

    spec.files = Dir['lib/**/*.rb']
    spec.executables = ['mixml']
    spec.require_paths = ['lib']

    spec.add_dependency 'commander', '~> 4.2'
    spec.add_dependency 'nokogiri', '~> 1.6'
    spec.add_dependency 'erubis', '~> 2.7'
    spec.add_dependency 'docile', '~> 1.1'

    spec.add_development_dependency 'bundler', '~> 1.6'
    spec.add_development_dependency 'rake'
    spec.add_development_dependency 'qed', '~> 2.9'
end
