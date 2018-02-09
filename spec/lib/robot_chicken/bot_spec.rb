require "spec_helper"

RSpec.describe RobotChicken::Bot do
  subject { described_class.new }

  describe "attributes", vcr: { cassette_name: :info } do
    it { expect(subject.client).to be_instance_of(Telegram::Bot::Client) }

    it { expect { subject }.to output(/Initializing MTG Helper \[#448967013\]/).to_stdout }
  end

  describe "listen" do
    context "when faraday fails", vcr: { cassette_name: :listen } do
      before { allow(subject.client).to receive(:listen).and_raise(Faraday::ConnectionFailed.new("Bad bot")) }

      it { expect { subject.listen }.to output(/Faraday failing\. Retrying\. Bad bot/).to_stdout }
    end
  end
end
