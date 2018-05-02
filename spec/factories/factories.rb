FactoryBot.define do
  factory :user, class: Telegram::Bot::Types::User do
    id            { rand(1000) }

    first_name    "Eduardo"
    last_name     "Maia"
    username      "emaiax"
    language_code "en-BR"
  end

  factory :chat, class: Telegram::Bot::Types::Chat do
    id         { rand(1000) }

    first_name "Eduardo"
    last_name  "Maia"
    username   "emaiax"
    type       "private"

    trait :group do
      type "group"
    end
  end

  factory :message, class: Telegram::Bot::Types::Message do
    message_id { rand(1000) }

    association :from, factory: :user, strategy: :build
    association :chat, factory: :chat, strategy: :build
  end

  factory :callback, class: Telegram::Bot::Types::CallbackQuery do
    id   { rand(1000) }

    data "card#c77d7dc5dbbaf945fddb20d77b0ca8d547c53d29"

    association :from,          factory: :user,    strategy: :build
    association :message,       factory: :message, strategy: :build
    association :chat_instance, factory: :chat,    strategy: :build
  end
end
