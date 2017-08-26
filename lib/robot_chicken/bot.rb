module RobotChicken
  class Bot
    include Singleton

    attr_reader :bot, :info

    def initialize
      @bot = TelegramBot.new(token: RobotChicken.api_token)

      RobotChicken.logger.info "Initializing #{info.first_name} [##{info.id}]"
    end

    def info
      @info ||= bot.get_me
    end

    def listen
      RobotChicken.logger.info "Listening..."

      bot.get_updates(fail_silently: true) do |message|
        RobotChicken.logger.info "from @#{message.from.username}: #{message.text}"
        command = message.get_command_for(bot)

        message.reply do |reply|
          case command
          when /greet/i
            reply.text = "Hello, #{message.from.first_name}!"
          else
            reply.text = "#{message.from.first_name}, have no idea what #{command.inspect} means."
          end

          RobotChicken.logger.info "to @#{message.from.username}: #{reply.text.inspect}"
          reply.send_with(bot)
        end
      end
    end
  end
end
