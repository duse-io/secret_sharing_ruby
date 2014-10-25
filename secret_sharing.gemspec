# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'secret_sharing/version'

Gem::Specification.new do |spec|
  spec.name          = 'secret_sharing'
  spec.version       = SecretSharing::VERSION
  spec.authors       = ['flower-pot']
  spec.email         = ['fbranczyk@gmail.com']
  spec.summary       = 'Ruby implementation of sharmir\'s secret sharing'
  spec.description   = 'Divide, share and reconstruct secrets.'
  spec.homepage      = 'https://github.com/duse-io/secret_sharing_ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = `git ls-files spec`.split($INPUT_RECORD_SEPARATOR)
  spec.require_paths = ['lib']
end
