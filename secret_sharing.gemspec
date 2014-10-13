# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'secret_sharing/version'

Gem::Specification.new do |spec|
  spec.name          = "secret_sharing"
  spec.version       = SecretSharing::VERSION
  spec.authors       = ["flower-pot"]
  spec.email         = ["fbranczyk@gmail.com"]
  spec.summary       = "Ruby implementation of sharmir's secret sharing"
  spec.description   = "Securely share divide and reconstruct secrets."
  spec.homepage      = "https://github.com/flower-pot/secret_sharing"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
