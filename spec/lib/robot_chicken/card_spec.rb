require "spec_helper"

RSpec.describe RobotChicken::Card do
  subject { described_class }

  describe ".find_by_id", vcr: { cassette_name: :find_card_by_id } do
    let(:inquisition) { subject.find_by_id("c77d7dc5dbbaf945fddb20d77b0ca8d547c53d29") }

    it { expect(inquisition).to be_an(MTG::Card) }

    it { expect(inquisition.id).to       eql("c77d7dc5dbbaf945fddb20d77b0ca8d547c53d29") }
    it { expect(inquisition.name).to     eql("Inquisition of Kozilek") }
    it { expect(inquisition.set).to      eql("ROE") }
    it { expect(inquisition.set_name).to eql("Rise of the Eldrazi") }
  end

  describe ".find_by_name", vcr: { cassette_name: :find_card_by_name } do
    let(:avacyn) { subject.find_by_name("avacyn") }

    let(:avacyn_names) do
      [
        "Archangel Avacyn",
        "Avacyn's Collar",
        "Avacyn's Judgment",
        "Avacyn's Pilgrim",
        "Avacyn's Pilgrim",
        "Avacyn's Pilgrim",
        "Avacyn, Angel of Hope",
        "Avacyn, Angel of Hope",
        "Avacyn, Angel of Hope",
        "Avacyn, Guardian Angel",
        "Avacyn, the Purifier",
        "Avacynian Missionaries",
        "Avacynian Priest",
        "Mask of Avacyn",
        "Scroll of Avacyn"
      ]
    end

    let(:avacyn_ids) do
      [
        "02ea5ddc89d7847abc77a0fbcbf2bc74e6456559",
        "9e12d76f3f4712d7c16d59622122cb48f69930fc",
        "ac43cc4332b269dae4659f38e5edd03925c24dab",
        "8c53699aa1e4421148797aeb6c5bd1d3cdf60ce8",
        "d95f507240b5e5e1a749c57bc1cf77113534661d",
        "4d4887c84298ee8831b77fb96bdab1b472af750a",
        "fa0dc16eedf10359a81f6cafac182332e755f2ed",
        "5dc1a24a6fe5ac8ad572d28b687febf318576cf4",
        "d4395abdd98279c90c27f03fd395c97a714cacf0",
        "6d03e7b566421d1fb049937b77f761e413f7cd03",
        "a1f94be9411d51f98e9b111c03ff55f5848ba30a",
        "407778acc5002260f093533b9948cd7f414ad478",
        "cc809065f80bae98b5304234cccf855f8c71ba23",
        "f849dee98d94e155182032b03db718e80585bb82",
        "961b97b9a23e020ae005023c9d7611d92212ee90"
      ]
    end

    it { expect(avacyn).to be_an(Array) }
    it { expect(avacyn.size).to eql(15) }

    it { expect(avacyn.map(&:id)).to   match_array(avacyn_ids) }
    it { expect(avacyn.map(&:name)).to match_array(avacyn_names) }
  end
end
