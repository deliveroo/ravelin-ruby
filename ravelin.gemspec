# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ravelin/version'

Gem::Specification.new do |spec|
  spec.name          = 'ravelin'
  spec.version       = Ravelin::VERSION
  spec.authors       = ['Sam Levy', 'Tommy Palmer', 'Gurkan Oluc', 'Mathilda Thompson']
  spec.email         = ['sam.levy@deliveroo.co.uk', 'tommy.palmer@deliveroo.co.uk', 'gurkan.oluc@deliveroo.co.uk', 'mathilda.thompson@deliveroo.co.uk']

  spec.summary       = %q{Ruby bindings for the Ravelin API}
  spec.description   = %q{Ravelin is a fraud detection tool. See https://www.ravelin.com for details.}
  spec.homepage      = 'https://developer.ravelin.com'
  spec.license       = 'MIT'

  spec.add_dependency('faraday', '~> 0.17')
  spec.add_dependency('faraday_middleware', '~> 0.14')

  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17.3'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'webmock', '~> 2.3'
end
