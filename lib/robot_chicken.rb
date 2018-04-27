require "logger"

module RobotChicken
  module_function

  autoload :Bot,        "robot_chicken/bot"
  autoload :Card,       "robot_chicken/card"
  autoload :Parser,     "robot_chicken/parser"
  autoload :Message,    "robot_chicken/message"

  module Processors
    autoload :Base,     "robot_chicken/processors/base"
    autoload :Message,  "robot_chicken/processors/message"
    autoload :Callback, "robot_chicken/processors/callback"
  end

  def logger
    @logger ||= Logger.new($stdout)
  end

  def api_token
    @api_token ||= ENV["API_TOKEN"]
  end

  def bot
    @bot ||= Bot.new
  end

  def run
    if api_token
      bot.listen
    else
      logger.warn "No API TOKEN found."
    end
  end

  %w[test development production].each do |environment|
    define_method "#{environment}?" do
      environment == (ENV.fetch("RUBY_ENV", "") || ENV.fetch("RACK_ENV", "") || "development")
    end
  end
end
