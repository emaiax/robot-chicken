module RobotChicken
  class Commands
    attr_reader :bot, :message

    def initialize(bot)
      @bot = bot
    end

    def reply(message)
      @message = message

      log_message

      case message
      when Telegram::Bot::Types::Message       then message_reply
      when Telegram::Bot::Types::CallbackQuery then callback_reply
      end
    end

    private

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

    def parse_card(card)
      [].tap do |text|
        text << "<b>#{card.name}</b> #{card.cmc.zero? ? "" : "- #{card.mana_cost} (CMC: #{card.cmc})"}"
        text << "#{card.type} #{card.type.downcase.include?("creature") ? " - #{card.power}/#{card.toughness}" : ""}"

        text << "\n"
        text << "<em>#{card.text[0..-1]}</em>"
      end.reject(&:empty?).join("\n")
    end

    def parse_rulings(card)
      rulings = card.rulings.sort_by(&:date).reverse.map { |ruling| "<b>#{ruling.date}</b>: #{ruling.text}" }.reject(&:empty?).join("\n\n")
      "<b>#{card.name}</b> rulings:\n\n#{rulings}"
    end

    def card_not_found
      bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, couldn't find anything about '#{message.text}'.")
    end

    def single_card(card)
      kb_cards = [
        card.image_url ? Telegram::Bot::Types::InlineKeyboardButton.new(text: "Picture", callback_data: "picture##{card.id}") : nil,
        card.rulings ? Telegram::Bot::Types::InlineKeyboardButton.new(text: "Rulings", callback_data: "rulings##{card.id}") : nil
      ].compact

      kb_back = []
      # kb_back << Telegram::Bot::Types::InlineKeyboardButton.new(text: "<< Back", callback_data: "back##{card.id}") if kb_cards.any?

      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: [kb_cards, kb_back])

      message_opts = { chat_id: message.from.id, text: parse_card(card), parse_mode: "HTML", reply_markup: markup }

      case message
      when Telegram::Bot::Types::Message       then bot.api.send_message(message_opts)
      when Telegram::Bot::Types::CallbackQuery then bot.api.edit_message_text(message_opts.merge(message_id: message.message.message_id))
      end
    end

    def multiple_cards(cards)
      kb_cards = cards.map { |card| Telegram::Bot::Types::InlineKeyboardButton.new(text: "#{card.name} (#{card.set})", callback_data: "card##{card.id}") }
      markup   = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb_cards)

      bot.api.send_message(chat_id: message.chat.id, text: "#{cards.size} cards found. Pick one:", reply_markup: markup)
    end

    def message_reply
      case message.text
      when /\/start/ then bot.api.send_message(chat_id: message.chat.id, text: welcome_message, parse_mode: "HTML")
      else
        cards = Card.find_by_name(message.text)

        case cards.size
        when 0 then card_not_found
        when 1 then single_card(cards.first)
        else multiple_cards(cards)
        end
      end
    end

    def callback_reply
      type, id = message.data.split("#")

      return unless %w(card picture rulings).include?(type)

      card = Card.find_by_id(id)

      case type
      when "card" then single_card(card)
      when "picture" then bot.api.send_photo(chat_id: message.from.id, photo: card.image_url)
      when "rulings" then bot.api.send_message(chat_id: message.from.id, text: parse_rulings(card), parse_mode: "HTML")
      end
    end

    def welcome_message
      [].tap do |text|
        text << "Hello, #{message.from.first_name}. Let's get started!"
        text << "Start searching your cards like 'emrakul'."
      end.join("\n\n")
    end
  end
end
