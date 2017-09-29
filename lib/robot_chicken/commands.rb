module RobotChicken
  class Commands
    attr_reader :bot

    def initialize(bot)
      @bot = bot
    end

    def reply(message)
      log_message(message)
      bot.api.send_message(chat_id: message.chat.id, text: create_reply_message(message))
    end

    private

    def create_reply_message(message)
      case message.text
      when "/start"
        "Hello, #{message.from.first_name}!"
      when "/stop"
        "Bye, #{message.from.first_name}"
      when "/card"
        Card.find(message.text)
      else
        "#{message.from.first_name}, I have no idea what '#{message.text}' means."
      end
    end

    def log_message(message)
      text  = "@#{message.from.username}: #{message.text}"
      title = message.chat.type == "group" ? "(#{message.chat.title})" : ""

      RobotChicken.logger.info "#{text} #{title}"
    end
  end
end
