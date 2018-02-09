require "spec_helper"

RSpec.describe RobotChicken::Message do
  describe "start" do
    let(:message) { build :message, text: "/start" }

    let(:response) do
      {
        action: :send_message,
        chat_id: message.chat.id,
        parse_mode: "HTML",
        text: "Hello, Eduardo. Let's get started!\n\nStart searching your cards like 'emrakul'."
      }
    end

    subject { described_class.reply message }

    it { expect(subject).to match_array(response) }
    it { expect { subject }.to output(/@emaiax: \/start/).to_stdout }

    it { expect { |b| described_class.reply(message, &b) }.to yield_with_args(response) }
  end

  describe "stop" do
    let(:message) { build :message, text: "/stop" }

    let(:response) do
      {
        action: :send_message,
        chat_id: message.chat.id,
        parse_mode: "HTML",
        text: "Goodbye cyah soon!"
      }
    end

    subject { described_class.reply message }

    it { expect(subject).to match_array(response) }
    it { expect { subject }.to output(/@emaiax: \/stop/).to_stdout }

    it { expect { |b| described_class.reply(message, &b) }.to yield_with_args(response) }
  end

  describe "azusa", vcr: { cassette_name: "message/single_card_azusa" } do
    let(:message) { build :message, text: "azusa" }

    let(:response) do
      {
        action: :send_message,
        chat_id: message.chat.id,
        parse_mode: "HTML",
        text: /Azusa, Lost but Seeking/,
        reply_markup: instance_of(Telegram::Bot::Types::InlineKeyboardMarkup)
      }
    end

    subject { described_class.reply message }

    it { expect(subject).to match_array(response) }
    it { expect { subject }.to output(/@emaiax: azusa/).to_stdout }

    it { expect { |b| described_class.reply(message, &b) }.to yield_with_args(response) }
  end
end
