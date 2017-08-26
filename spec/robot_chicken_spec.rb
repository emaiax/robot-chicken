require "spec_helper"

RSpec.describe RobotChicken do
  describe "module functions" do
    before { ENV.delete("API_TOKEN") }

    it { expect(subject.api_token).to be_nil }
    it { expect(subject.logger).to be_an_instance_of(Logger) }
  end
end
