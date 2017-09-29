require "vcr"
require "pry"
require "simplecov"
require "pry-byebug"

require "telegram/bot"

require "bot_logger"
require "robot_chicken"

VCR.configure do |config|
  config.hook_into :faraday
  config.configure_rspec_metadata!
  config.cassette_library_dir = "spec/cassettes"
end

SimpleCov.start do
  minimum_coverage ENV.fetch("MINIMUM_COVERAGE") { 100 }
end

RSpec.configure do |config|
  config.before(:each) do
    allow(RobotChicken).to receive(:logger).and_return(BotLogger.new)

    allow(RobotChicken).to receive(:api_token).and_return("448967013:123")
  end
end
