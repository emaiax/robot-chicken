require "singleton"

module RobotChicken
  class Bot
    include Singleton

    attr_reader :bot, :info, :commands

    def initialize
      @bot      = TelegramBot.new(token: RobotChicken.api_token)
      @commands = Commands.new(bot)

      RobotChicken.logger.info "Initializing #{info.first_name} [##{info.id}]"
    end

    def info
      @info ||= bot.get_me
    end

    def listen
      bot.get_updates(fail_silently: false) do |message|
        RobotChicken.logger.info "from @#{message.from.username}: #{message.text}"

        message.reply do |reply|
          reply.text = commands.reply(message)
          reply.send_with(bot)

          RobotChicken.logger.info "to @#{message.from.username}: #{reply.text.inspect}"
        end
      end
    end
  end
end
