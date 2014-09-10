# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dert/version'

Gem::Specification.new do |spec|
  spec.name          = 'dert'
  spec.version       = Dert::VERSION
  spec.authors       = ['Coleton Pierson']
  spec.email         = ['coleton.pierson@praetorian.com']
  spec.summary       = %q{DNS Enumeration and Reconnaissance Tool}
  spec.description   = %q{Tool used to enumerate hosts and domains for reconnaissance during a penetration test.}
  spec.homepage      = 'http://praetorian.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10'
  spec.add_runtime_dependency 'dnsruby', '~> 1'
  spec.add_runtime_dependency 'rex', '~> 1.0'
end
