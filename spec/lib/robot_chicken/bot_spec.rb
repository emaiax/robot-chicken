require "spec_helper"

RSpec.describe RobotChicken::Bot do
  subject { described_class.new }

  describe "bot info", vcr: { cassette_name: :bot_info } do
    it { expect(subject.client).to be_instance_of(Telegram::Bot::Client) }

    it { expect { subject }.to output(/Initializing MTG Helper \[#448967013\]/).to_stdout }
  end

  xdescribe "listen", vcr: { cassette_name: :conversation, allow_playback_repeats: true }do
    context "when faraday fails" do
      before { allow(subject.client).to receive(:listen).and_raise(Faraday::ConnectionFailed.new("Bad bot")) }

      it { expect { subject.listen }.to output(/Faraday failing\. Retrying\. Bad bot/).to_stdout }
    end

    context "starts listening to Telegram's API" do
      it { expect { subject.listen }.to output(/fuck/).to_stdout }
    end
  end
end
