# frozen_string_literal: true

module Analysis
  class MaxQueryComplexity
    class ConnectionScopeType < BaseScopeType
      def valid?
        if node_argument.nil?
          raise GraphQL::AnalysisError, "Connection '#{field_definition.name}' requires the argument 'first' or 'last' to be supplied."
        elsif !node_argument.value.between?(1, 100)
          raise GraphQL::AnalysisError, "Connection '#{field_definition.name}' argument '#{node_argument.name}' must be between 1 - 100."
        end

        true
      end

      def own_complexity(child_complexity)
        (node_argument.value * complexity) + child_complexity
      end

      private

      def node_argument
        @node_argument ||= @node.arguments.find { |arg| %w[first last].include?(arg.name) }
      end
    end
  end
end
