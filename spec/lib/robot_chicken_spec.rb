require "spec_helper"

RSpec.describe RobotChicken do
  it { expect(described_class.logger).to be_instance_of(BotLogger) }

  context "with api token", vcr: { cassette_name: :info } do
    it "creates bot instance and start to listen" do
      expect(described_class.bot).to receive(:listen)

      subject.run
    end
  end

  context "without api token" do
    before { allow(subject).to receive(:api_token).and_return(nil) }

    it { expect { subject.run }.to output(/No API TOKEN found/).to_stdout }
  end
end
