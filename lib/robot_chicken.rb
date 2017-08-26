module RobotChicken
  extend self

  autoload :Bot, "robot_chicken/bot"

  def logger
    @logger ||= Logger.new(STDOUT)
  end

  def api_token
    @api_token ||= ENV["API_TOKEN"]
  end

  def run
    if api_token
      Bot.instance.listen
    else
      logger.fatal "No API TOKEN found."
    end
  end
end
