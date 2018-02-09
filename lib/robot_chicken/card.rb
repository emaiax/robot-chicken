module RobotChicken
  class Card
    class << self
      def find_by_id(id)
        MTG::Card.find(id)
      end

      def find_by_name(name)
        MTG::Card.where(name: name).all.sort_by(&:name)
      end
    end
  end
end
