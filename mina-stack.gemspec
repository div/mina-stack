# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mina-stack/version'

Gem::Specification.new do |spec|
  spec.name          = "mina-stack"
  spec.version       = Mina::Stack::VERSION
  spec.authors       = ["Igor Davydov"]
  spec.email         = ["iskiche@gmail.com"]
  spec.description   = %q{Easy deploy of rails app stack with mina on ubuntu servers}
  spec.summary       = %q{Mina + stack}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rake"
  spec.add_dependency "mina"
  spec.add_dependency "highline"
  spec.add_development_dependency "bundler", "~> 1.3"
end
