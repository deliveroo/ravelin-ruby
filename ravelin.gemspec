# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ravelin/version'

Gem::Specification.new do |spec|
  spec.name          = 'ravelin'
  spec.version       = Ravelin::VERSION
  spec.authors       = ['Sam Levy']
  spec.email         = ['sam.levy@deliveroo.co.uk']

  spec.summary       = %q{Ruby bindings for the Ravelin API}
  spec.description   = %q{Ravelin is a fraud detection tool. See https://www.ravelin.com for details.}
  spec.homepage      = 'https://developer.ravelin.com'
  spec.license       = 'MIT'

  spec.add_dependency('faraday', '~> 0.9')
  spec.add_dependency('faraday_middleware', '~> 0.10')

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 1.22'
end
