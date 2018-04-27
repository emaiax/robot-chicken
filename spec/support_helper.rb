require "vcr"
require "pry"
require "simplecov"
require "pry-byebug"
require "factory_bot"

require "mtg_sdk"
require "telegram/bot"

require "bot_logger"
require "robot_chicken"

VCR.configure do |config|
  config.hook_into :faraday
  config.configure_rspec_metadata!
  config.cassette_library_dir = "spec/cassettes"
end

SimpleCov.start { minimum_coverage ENV.fetch("MINIMUM_COVERAGE", 100) }

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.before(:each) do
    allow(RobotChicken).to receive(:logger).and_return    BotLogger.new
    allow(RobotChicken).to receive(:api_token).and_return "448967013:123"

    # allow(RobotChicken).to receive(:api_token).and_return "465527379:AAH__TKK53YBun2KMdC3Ja1wM8SO7tkYlUU"
    # %s/465527379:AAH__TKK53YBun2KMdC3Ja1wM8SO7tkYlUU/448967013:123/g
  end
end
