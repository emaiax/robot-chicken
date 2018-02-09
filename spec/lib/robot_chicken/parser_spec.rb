require "spec_helper"

RSpec.describe RobotChicken::Parser do
  let(:parsed_card) do
    "<strong>Inquisition of Kozilek</strong> - {B} (CMC: 1)\n" \
    "Sorcery\n\n" \
    "<em>Target player reveals his or her hand. You choose a nonland card from it with converted mana cost 3 or less. That player discards that card.</em>"
  end

  let(:parsed_rulings) do
    "<strong>Inquisition of Kozilek</strong> rulings:\n\n" \
    "<strong>2014-02-01:</strong> If you target yourself with this spell, you must reveal your entire hand to the other players just as any other player would."
  end

  let(:inquisition) { RobotChicken::Card.find_by_id("c77d7dc5dbbaf945fddb20d77b0ca8d547c53d29") }

  describe "no type", vcr: { cassette_name: :find_card_by_id } do
    subject { described_class.parse inquisition }

    it { expect { subject }.to raise_error(/Not a valid parsing type/) }
  end

  describe "text", vcr: { cassette_name: :find_card_by_id } do
    subject { described_class.parse inquisition, type: :text }

    it { expect(subject).to eql(parsed_card) }
  end

  describe "rulings", vcr: { cassette_name: :find_card_by_id } do
    subject { described_class.parse inquisition, type: :rulings }

    it { expect(subject).to eql(parsed_rulings) }
  end
end
