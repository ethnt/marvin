# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'marvin/version'

Gem::Specification.new do |spec|
  spec.name          = 'marvin'
  spec.version       = Marvin::VERSION
  spec.authors       = ['Ethan Turkeltaub']
  spec.email         = ['ethan.turkeltaub@gmail.com']

  spec.summary       = 'Marvin is a compiler written in Ruby.'
  spec.description   = 'Marvin is a compiler written in Ruby.'
  spec.homepage      = 'https://github.com/eturk/marvin'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'yell', '~> 2.0.5'

  spec.add_development_dependency 'bundler', '~> 1.11'
end
