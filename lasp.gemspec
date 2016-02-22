# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lasp/version'

Gem::Specification.new do |spec|
  spec.name          = "lasp"
  spec.version       = Lasp::VERSION
  spec.authors       = ["Jimmy Börjesson"]
  spec.email         = ["lagginglion@gmail.com"]

  spec.summary       = %q{A simple Lisp-dialect programming language inspired by Clojure.}
  spec.homepage      = "https://github.com/alcesleo/lasp"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.0'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
end
