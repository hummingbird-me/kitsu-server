# frozen_string_literal: true

module Analysis
  class MaxQueryComplexity < GraphQL::Analysis::AST::Analyzer
    # State for the query complexity calculation:
    # - `complexities_on_type` holds complexity scores for each type in an IRep node
    def initialize(query)
      super
      @complexities_on_type_by_query = {}
      @errors = []
    end

    def analyze?
      true
    end

    def result
      return @errors.uniq if @errors.present?

      max_possible_complexity
    end

    # NOTE: I can't figure out how to trigger this with a test.
    def on_enter_field(node, _parent, visitor)
      # We don't want to visit fragment definitions,
      # we'll visit them when we hit the spreads instead
      return if visitor.visiting_fragment_definition?
      # We don't visit if the field is not being used
      return if visitor.skipping?
      # If not a connection or custom type, we can skip.
      return unless allowed_type?(node, visitor.field_definition)

      generated_complexity = complexity_type(node, visitor)

      # This will actually raise an error if invalid.
      begin
        generated_complexity.valid?
      rescue GraphQL::AnalysisError => e
        @errors << e
      end

      parent_type = visitor.parent_type_definition
      field_key = node.alias || node.name
      # Find the complexity calculation for this field --
      # if we're re-entering a selection, we'll already have one.
      # Otherwise, make a new one and store it.
      #
      # `node` and `visitor.field_definition` may appear from a cache,
      # but I think that's ok. If the arguments _didn't_ match,
      # then the query would have been rejected as invalid.
      complexities_on_type = @complexities_on_type_by_query[visitor.query] ||= [
        BaseScopeType.new(
          query,
          visitor.response_path
        )
      ]

      complexity = complexities_on_type.last.scoped_children[parent_type][field_key] ||= generated_complexity

      # Push it on the stack.
      complexities_on_type.push(complexity)
    end

    # NOTE: unsure why we need this.
    def on_leave_field(node, _parent, visitor)
      # We don't want to visit fragment definitions,
      # we'll visit them when we hit the spreads instead
      return if visitor.visiting_fragment_definition?
      # We don't visit if the field is not being used
      return if visitor.skipping?
      # If not a connection or custom type, we can skip.
      return unless allowed_type?(node, visitor.field_definition)

      complexities_on_type = @complexities_on_type_by_query[visitor.query]
      complexities_on_type.pop
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

    # We are checking if a field is a connection or custom type
    def allowed_type?(node, field_definition)
      return true if field_definition.connection?
      # we don't care about the head query_type.
      return false if field_definition.owner == Types::QueryType
      # I am not sure if there is a better way to identify these.
      return true if node.children.present?

      false
    end

    def complexity_type(node, visitor)
      prefix = visitor.field_definition.connection? ? 'Connection' : 'Custom'

      "Analysis::MaxQueryComplexity::#{prefix}ScopeType".safe_constantize.new(
        visitor.query,
        visitor.response_path,
        node: node,
        field_definition: visitor.field_definition
      )
    end
  end
end
