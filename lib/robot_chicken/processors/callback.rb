module RobotChicken
  module Processors
    class Callback < Base
      class << self
        private

        CALLBACKS = %w[card picture rulings].freeze

        def reply
          type, id = callback_data.split("#")

          raise NotImplementedError, "Callback not found" unless CALLBACKS.include?(type)

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
