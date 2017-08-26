module RobotChicken
  class Commands
    attr_reader :bot

    def initialize(bot)
      @bot = bot
    end

    def reply(message)
      command = message.get_command_for(bot)

      case command
      when /greet/i
        "Hello, #{message.from.first_name}!"
      else
        "#{message.from.first_name}, have no idea what #{command.inspect} means."
      end
    end
  end
end
