module RobotChicken
  module Processors
    class Callback < Base
      class << self
        private

        def reply
          type, id = callback_data.split("#")

          card = Card.find_by_id(id)

          case type
          when "picture" then { photo: card.image_url, action: :send_photo }
          when "rulings" then { text: Parser.parse(card, type: :rulings), action: :send_message }
          else
            cards_reply([card]).tap do |reply|
              reply.delete(:reply_markup) unless reply[:reply_markup]
            end.merge(action: :edit_message)
          end
        end
      end
    end
  end
end
