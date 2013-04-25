# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'axlsx/dsl/version'

Gem::Specification.new do |spec|
  spec.name          = "axlsx-dsl"
  spec.version       = Axlsx::DSL::VERSION
  spec.authors       = ["Antonin Amand"]
  spec.email         = ["antonin@lewattman.com"]
  spec.description   = %q{axlsx-dsl provides sugar syntax and stylesheet helpers for axlsx}
  spec.summary       = %q{DSL on top of axlsx for generating excel spreadsheets}
  spec.homepage      = "http://github.com/lewattman/asxls-dsl"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency "axlsx", "~> 1.3.4"
  spec.add_runtime_dependency "activesupport", "~> 3.2.11"
end
