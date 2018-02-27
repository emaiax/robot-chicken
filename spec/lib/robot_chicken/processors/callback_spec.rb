require "spec_helper"

RSpec.describe RobotChicken::Processors::Callback do
  subject { described_class.process(message.message, message.data) }

  describe "for card details", vcr: { cassette_name: "callback/card_details" } do
    let(:message) { build :callback, data: "card#c77d7dc5dbbaf945fddb20d77b0ca8d547c53d29" }

    it { expect(subject.keys).to match_array(%i[action text reply_markup]) }

    it { expect(subject[:action]).to eql(:edit_message) }

    it { expect(subject[:text]).to match(/Inquisition of Kozilek/) }

    it { expect(subject[:reply_markup]).to be_an(Telegram::Bot::Types::InlineKeyboardMarkup) }

    it { expect(subject[:reply_markup].inline_keyboard.flatten.size).to eql(2) }

    it { expect(subject[:reply_markup].inline_keyboard[0][0].text).to          eql("Picture") }
    it { expect(subject[:reply_markup].inline_keyboard[0][0].callback_data).to eql("picture#c77d7dc5dbbaf945fddb20d77b0ca8d547c53d29") }

    it { expect(subject[:reply_markup].inline_keyboard[1][0].text).to          eql("Rulings") }
    it { expect(subject[:reply_markup].inline_keyboard[1][0].callback_data).to eql("rulings#c77d7dc5dbbaf945fddb20d77b0ca8d547c53d29") }
  end

  describe "for card picture", vcr: { cassette_name: "callback/card_picture" } do
    let(:message) { build :callback, data: "picture#c77d7dc5dbbaf945fddb20d77b0ca8d547c53d29" }

    it { expect(subject.keys).to match_array(%i[action photo]) }

    it { expect(subject[:action]).to eql(:send_photo) }

    it { expect(subject[:photo]).to eql("http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=193428&type=card") }

    it { expect(subject[:reply_markup]).to be_nil }
  end

  describe "for card rulings", vcr: { cassette_name: "callback/card_rulings" } do
    let(:message) { build :callback, data: "rulings#c77d7dc5dbbaf945fddb20d77b0ca8d547c53d29" }

    it { expect(subject.keys).to match_array(%i[action text]) }

    it { expect(subject[:action]).to eql(:send_message) }

    it { expect(subject[:text]).to match(/you must reveal your entire hand to the other players/) }

    it { expect(subject[:reply_markup]).to be_nil }
  end
end
