require "logger"

module RobotChicken
  module_function

  autoload :Bot,      "robot_chicken/bot"
  autoload :Card,     "robot_chicken/card"
  autoload :Commands, "robot_chicken/commands"

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
end
