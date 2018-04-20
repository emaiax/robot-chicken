require "spec_helper"

RSpec.describe RobotChicken::Processors::Base do
  it { expect { described_class.process(nil) }.to raise_error NotImplementedError }
end
