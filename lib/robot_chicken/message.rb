module RobotChicken
  class Message
    class << self
      attr_reader :message, :response

      def reply(message, &block)
        @message  = message
        @response = { chat_id: chat_id, parse_mode: "HTML" }

        text = message.respond_to?(:text) ? message.text : nil

        case text
        when %r{\/start} then response.merge! action: :send_message, text: "Hello, Eduardo. Let's get started!\n\nStart searching your cards like 'emrakul'."
        when %r{\/stop}  then response.merge! action: :send_message, text: "Goodbye cyah soon!"
        else response.merge! process_message
        end

        yield response if block_given?

        response
      end

      private

      def process_message
        case message
        when Telegram::Bot::Types::Message       then Processors::Message.process(message)
        when Telegram::Bot::Types::CallbackQuery then Processors::Callback.process(message.message, message.data)
        end
      end

      def log_message
        case message
        when Telegram::Bot::Types::Message then
          text = "@#{message.from.username}: #{message.text}"
          title = message.chat.type == "group" ? "(#{message.chat.title})" : ""
        when Telegram::Bot::Types::CallbackQuery then
          text = "[callback] @#{message.from.username}: #{message.data}"
          title = message.message.chat.type == "group" ? "(#{message.chat.title})" : ""
        else ""
        end

        RobotChicken.logger.info "#{text} #{title}"
      end

      def chat_id
        case message
        when Telegram::Bot::Types::Message then       message.chat.id
        when Telegram::Bot::Types::CallbackQuery then message.message.chat.id
        end
      end
    end
  end
end
