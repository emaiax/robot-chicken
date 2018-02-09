module RobotChicken
  module Processors
    class Message < Base
      class << self
        attr_reader :message

        def process(message)
          @message = message

          reply
        end

        private

        def reply
          cards = Card.find_by_name(message.text)

          cards_reply(cards).tap do |reply|
            reply.delete(:reply_markup) unless reply[:reply_markup]
          end.merge(action: :send_message)
        end
      end
    end
  end
end
