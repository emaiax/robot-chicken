require "spec_helper"

RSpec.describe RobotChicken::Bot do
  describe "attributes", vcr: { cassette_name: :info } do
    subject { described_class.instance }

    it { expect(subject.bot).to      be_instance_of(Telegram::Bot::Client) }
    it { expect(subject.commands).to be_instance_of(RobotChicken::Commands) }

    it { expect { subject }.to output(/Initializing MTG Helper \[#448967013\]/).to_stdout }
  end
end
