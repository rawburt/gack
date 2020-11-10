# frozen_string_literal: true

require_relative 'lib/gack/version'

Gem::Specification.new do |s|
  s.name        = 'gack'
  s.version     = Gack::VERSION.dup
  s.date        = '2020-11-10'
  s.summary     = 'Basic Gemini server'
  s.description = 'Gack helps you build Gemini protocol applications with Ruby.'
  s.authors     = ['Robert Peterson']
  s.email       = 'me@robertp.me'
  s.files       = Dir['README.md', 'gack.gemspec', 'lib/**/*']
  s.homepage    = 'https://github.com/rawburt/gack'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.6.0'

  s.add_development_dependency 'bundler', '~> 2.1'
  s.add_development_dependency 'rspec', '~> 3.10'
  s.add_development_dependency 'rubocop', '~> 1.2'
  s.add_development_dependency 'rubocop-rspec', '~> 2.0'
  s.add_development_dependency 'simplecov', '~> 0.19'
end
