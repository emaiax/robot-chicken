module RobotChicken
  class Parser
    class << self
      attr_reader :card

      TYPES = %i[text rulings]

      def parse(card, type: nil)
        raise "Not a valid parsing type" unless TYPES.include?(type)

        @card = card

        send(type)
      end

      private

      def text
        [header, type, "\n", rules].reject(&:empty?).map(&:strip).join("\n")
      end

      def header
        "<strong>#{card.name}</strong> #{card.cmc.zero? ? "" : "- #{card.mana_cost} (CMC: #{card.cmc})"}"
      end

      def type
        "#{card.type} #{card.type.downcase.include?("creature") ? " - #{card.power}/#{card.toughness}" : ""}"
      end

      def rules
        "<em>#{card.text[0..-1]}</em>"
      end

      def rulings
        "<strong>#{card.name}</strong> rulings:\n\n#{parsed_rulings}"
      end

      def parsed_rulings
        card.rulings
          .sort_by(&:date)
          .reverse
          .map { |ruling| "<strong>#{ruling.date}:</strong> #{ruling.text}" }
          .reject(&:empty?)
          .join("\n\n")
      end
    end
  end
end
