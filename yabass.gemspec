# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yabass/version'

Gem::Specification.new do |spec|
  spec.name          = "yabass"
  spec.version       = Yabass::VERSION
  spec.authors       = ["syumai"]
  spec.email         = ["syumai@gmail.com"]

  spec.summary       = "Static site generator with YAML based simple routing"
  spec.homepage      = "https://github.com/syumai/yabass/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sass"

  spec.add_development_dependency "bundler", "~> 1.12"
end
