# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'version'

Gem::Specification.new do |spec|
  spec.name          = "i18n-translated-backend"
  spec.version       = I18nTranslatedBackend::Version
  spec.authors       = ["Nikita Fedyashev"]
  spec.email         = ["nfedyashev@gmail.com"]
  spec.summary       = %q{Translate your locale tokens on the fly using Microsoft Azure Translate backend}
  spec.homepage      = "https://github.com/nfedyashev/i18n-translated-backend.rb"
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/*', '*.md', '*.gemspec', 'Gemfile', 'Rakefile']

  spec.required_ruby_version     = Gem::Requirement.new('>= 1.9.3')
  spec.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')

  spec.add_dependency 'i18n', '>= 0.5'

  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_development_dependency 'rake', '~> 10'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'simplecov'
end
