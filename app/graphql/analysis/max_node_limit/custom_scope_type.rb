# frozen_string_literal: true

module Analysis
  class MaxNodeLimit
    class CustomScopeType < BaseScopeType
      def total_nodes(child_nodes_amount)
        child_nodes_amount + 1
      end
    end
  end
end
