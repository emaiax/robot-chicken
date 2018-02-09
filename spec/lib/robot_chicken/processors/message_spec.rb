require "spec_helper"

RSpec.describe RobotChicken::Processors::Message do
  subject { described_class.process(message) }

  describe "no card found", vcr: { cassette_name: "message/card_not_found" } do
    let(:message) { build :message, text: "nocardfound" }

    it { expect(subject[:action]).to eql(:send_message) }

    it { expect(subject[:text]).to match(/Sorry, I couldn't find anything about 'nocardfound'/) }
  end

  describe "single card found", vcr: { cassette_name: "message/single_card_azusa" } do
    let(:message) { build :message, text: "azusa" }

    it { expect(subject.keys).to match_array([:action, :text, :reply_markup]) }

    it { expect(subject[:action]).to eql(:send_message) }

    it { expect(subject[:text]).to match(/Azusa, Lost but Seeking/) }

    it { expect(subject[:reply_markup]).to be_an(Telegram::Bot::Types::InlineKeyboardMarkup) }

    it { expect(subject[:reply_markup].inline_keyboard.flatten.size).to eql(1) }

    it { expect(subject[:reply_markup].inline_keyboard[0][0].text).to          eql("Picture") }
    it { expect(subject[:reply_markup].inline_keyboard[0][0].callback_data).to eql("picture#c6e517f4120f7fac9a1611414e29cdfec716e8e4") }
  end

  describe "multiple cards found", vcr: { cassette_name: "message/multiple_cards_bleh" } do
    let(:message) { build :message, text: "bleh" }

    it { expect(subject.keys).to match_array([:action, :text, :reply_markup]) }

    it { expect(subject[:action]).to eql(:send_message) }

    it { expect(subject[:text]).to match(/3 cards found\. Pick one:/) }

    it { expect(subject[:reply_markup]).to be_an(Telegram::Bot::Types::InlineKeyboardMarkup) }

    it { expect(subject[:reply_markup].inline_keyboard.flatten.size).to eql(3) }

    it { expect(subject[:reply_markup].inline_keyboard[0][0].text).to eql("Rubblehulk (pPRE)") }
    it { expect(subject[:reply_markup].inline_keyboard[0][1].text).to eql("Rubblehulk (C16)") }
    it { expect(subject[:reply_markup].inline_keyboard[1][0].text).to eql("Rubblehulk (GTC)") }

    it { expect(subject[:reply_markup].inline_keyboard[0][0].callback_data).to eql("card#bedb3026dfe71b43bc4043b7d8c0cf45c9794285") }
    it { expect(subject[:reply_markup].inline_keyboard[0][1].callback_data).to eql("card#be3b62fdca6c9fc17da1090c80692805ecc10593") }
    it { expect(subject[:reply_markup].inline_keyboard[1][0].callback_data).to eql("card#946f31296c4901137484cf20612e6eee304cf51f") }
  end
end
