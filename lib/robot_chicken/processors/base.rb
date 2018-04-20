module RobotChicken
  module Processors
    class Base
      class << self
        attr_reader :message, :callback_data

        def process(message, callback_data = nil)
          @message       = message
          @callback_data = callback_data

          reply
        end

        private

        def reply
          raise NotImplementedError, "missing"
        end

        def cards_reply(cards)
          if cards.size.zero?
            { text: cards_text(cards) }
          else
            { text: cards_text(cards), reply_markup: reply_markup(cards_buttons(cards)) }
          end
        end

        def cards_text(cards)
          case cards.size
          when 0 then "Sorry, I couldn't find anything about '#{message.text}'."
          when 1 then Parser.parse(cards.first, type: :text)
          else "#{cards.size} cards found. Pick one:"
          end
        end

        def inline_button(text, data)
          Telegram::Bot::Types::InlineKeyboardButton.new(text: text, callback_data: data)
        end

        def reply_markup(buttons)
          Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: buttons)
        end

        def cards_buttons(cards)
          if cards.size > 1
            cards.map { |card| inline_button("#{card.name} (#{card.set})", "card##{card.id}") }.each_slice(2).map { |btn| btn }
          else
            [
              cards.first.image_url ? inline_button("Picture", "picture##{cards.first.id}") : nil,
              cards.first.rulings   ? inline_button("Rulings", "rulings##{cards.first.id}") : nil
            ].compact
          end
        end
      end
    end
  end
end
