# frozen_string_literal: true

module Analysis
  class MaxQueryComplexity
    class CustomScopeType < BaseScopeType
      def own_complexity(child_complexity)
        complexity + child_complexity
      end
    end
  end
end
