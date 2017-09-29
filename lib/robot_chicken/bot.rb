require "singleton"
require "telegram/bot"

module RobotChicken
  class Bot
    include Singleton

    attr_reader :bot, :commands

    def initialize
      @bot      = Telegram::Bot::Client.new(RobotChicken.api_token)
      @commands = Commands.new(bot)

      RobotChicken.logger.info "Initializing #{bot_info.dig("result", "first_name")} [##{bot_info.dig("result", "id")}]"
    end

    def bot_info
      @bot_info ||= bot.api.get_me
    end

    def listen
      bot.listen { |message| commands.reply(message) }
    rescue Faraday::ConnectionFailed => e
      RobotChicken.logger.warn "Faraday failing. Retrying. #{e}"
      retry
    end
  end
end
