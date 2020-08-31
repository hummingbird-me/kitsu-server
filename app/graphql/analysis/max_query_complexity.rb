# frozen_string_literal: true

module Analysis
  class MaxQueryComplexity < GraphQL::Analysis::AST::Analyzer
    # State for the query complexity calculation:
    # - `complexities_on_type` holds complexity scores for each type in an IRep node
    def initialize(query)
      super
      @complexities_on_type_by_query = {}
    end

    def analyze?
      true
    end

    def result
      max_possible_complexity
    end

    # NOTE: I can't figure out how to trigger this with a test.
    def on_enter_field(node, parent, visitor)
      # We don't want to visit fragment definitions,
      # we'll visit them when we hit the spreads instead
      return if visitor.visiting_fragment_definition?
      # We don't visit if the field is not being used
      return if visitor.skipping?

      parent_type = visitor.parent_type_definition
      field_key = node.alias || node.name
      # Find the complexity calculation for this field --
      # if we're re-entering a selection, we'll already have one.
      # Otherwise, make a new one and store it.
      #
      # `node` and `visitor.field_definition` may appear from a cache,
      # but I think that's ok. If the arguments _didn't_ match,
      # then the query would have been rejected as invalid.
    end

    def on_leave_field(node, parent, visitor)

    end

    private

    # @return [Integer]
    def max_possible_complexity
      @complexities_on_type_by_query.reduce(0) do |total, (query, complexities_on_type)|
        root_complexity = complexities_on_type.last
        # Use this entry point to calculate the total complexity
        total_complexity_for_query = merged_max_complexity_for_scopes(query, [root_complexity.scoped_children])
        total + total_complexity_for_query
      end
    end
  end
end
