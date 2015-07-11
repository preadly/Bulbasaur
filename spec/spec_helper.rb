if ENV['COVERAGE'] == 'on'
  require "simplecov"
  SimpleCov.minimum_coverage 90
  SimpleCov.start
end

require "bundler/setup"
Bundler.setup

require "bulbasaur"
require "simplecov"

RSpec.configure do |config|
    # some (optional) config here
end
