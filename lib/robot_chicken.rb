require "logger"

module RobotChicken
  module_function

  autoload :Bot,      "robot_chicken/bot"
  autoload :Commands, "robot_chicken/commands"

  def logger
    @logger ||= Logger.new($stdout)
  end

  def api_token
    @api_token ||= ENV["API_TOKEN"]
  end

  def run
    if api_token
      Bot.instance.listen
    else
      logger.warn "No API TOKEN found."
    end
  end
end
