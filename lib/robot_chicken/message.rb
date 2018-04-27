module RobotChicken
  class Message
    class << self
      START_TEXT = "Hello, Eduardo. Let's get started!\n\nStart searching cards like 'emrakul'.".freeze
      STOP_TEXT  = "Goodbye cyah soon!".freeze

      attr_reader :message, :response

      def reply(message)
        @message  = message
        @response = { chat_id: chat_id, parse_mode: "HTML" }

        text = message.respond_to?(:text) ? message.text : nil

        RobotChicken.logger.info "@#{message.from.username}: #{text}"

        response.merge!(process_message(text))

        yield response if block_given?

        response
      end

      private

      def process_message(text)
        case text
        when %r{\/start} then { action: :send_message, text: START_TEXT }
        when %r{\/stop}  then { action: :send_message, text: STOP_TEXT }
        else process_reply
        end
      end

      def process_reply
        case message
        when Telegram::Bot::Types::Message       then Processors::Message.process(message)
        when Telegram::Bot::Types::CallbackQuery then Processors::Callback.process(message.message, message.data)
        end
      end

      def chat_id
        case message
        when Telegram::Bot::Types::Message       then message.chat.id
        when Telegram::Bot::Types::CallbackQuery then message.message.chat.id
        end
      end
    end
  end
end
