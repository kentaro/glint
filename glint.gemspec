# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'glint/version'

Gem::Specification.new do |spec|
  spec.name          = "glint"
  spec.version       = Glint::VERSION
  spec.authors       = ["Kentaro Kuribayashi"]
  spec.email         = ["kentarok@gmail.com"]
  spec.description   = %q{Glint is a library which allows you to fire arbitrary server processes programatically and ensures the processes are shutdown when your code exit}
  spec.summary       = %q{Firebombs arbitrary server processs for tests.}
  spec.homepage      = "http://github.com/kentaro/glint"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 1.9.2'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.12"
end
