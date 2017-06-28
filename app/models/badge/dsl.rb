class Badge
  module DSL
    extend ActiveSupport::Concern

    class Rank
      attr_reader :goal

      def initialize(&block)
        super
        instance_eval(&block)
      end

      def bestow_when(goal)
        @goal = goal
      end
    end

    included do
      class_attribute :_progress, :_ranks, :_hidden
      protected :_progress, :_ranks, :_hidden

      self._ranks = {}
      self._hidden = false
    end

    class_methods do
      def progress(&block)
        self._progress = block
      end

      def rank(num, &block)
        _ranks[num] = Rank.new(&block).goal
      end

      # Declare the goal for the badge
      def bestow_when(value = nil)
        _ranks[1] = value ? ->(progress) { value / progress } : Proc.new
      end

      def hidden
        self._hidden = true
      end

      def hidden?
        _hidden
      end
    end
  end
end
