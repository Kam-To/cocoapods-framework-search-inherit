# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-framework-search-inherit/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-framework-search-inherit'
  spec.version       = CocoapodsFrameworkSearchInherit::VERSION
  spec.authors       = ['Kam']
  spec.email         = ['kamtoto.au@gmail.com']
  spec.description   = %q{A short description of cocoapods-framework-search-inherit.}
  spec.summary       = %q{A longer description of cocoapods-framework-search-inherit.}
  spec.homepage      = 'https://github.com/Kam-To/cocoapods-framework-search-inherit'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
