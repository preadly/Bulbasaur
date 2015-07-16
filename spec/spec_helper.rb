if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require "bundler/setup"
Bundler.setup

require "bulbasaur"
require "webmock/rspec"

RSpec.configure do |config|

  config.after(:suite) do
    WebMock.disable_net_connect!(:allow => 'codeclimate.com')
  end

end
