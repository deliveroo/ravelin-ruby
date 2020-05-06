$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'ravelin'
require 'webmock/rspec'

Dir["./spec/support/**/*.rb"].sort.each {|f| require f}
