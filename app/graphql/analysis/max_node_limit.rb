# frozen_string_literal: true

module Analysis
  class MaxNodeLimit < GraphQL::Analysis::AST::Analyzer
    NODE_LIMIT = 500_000

    def initialize(query)
      super

      @nodes_on_type_by_query = {}
      @errors = []
    end

    # @return [Array<GraqhQL::AnalysisError>, GraqhQL::AnalysisError, nil]
    def result
      return @errors.uniq if @errors.present?
      return max_possible_nodes_limit_error if max_possible_nodes > NODE_LIMIT

      nil
    end

    def on_enter_field(node, _parent, visitor)
      # We don't want to visit fragment definitions,
      # we'll visit them when we hit the spreads instead
      return if visitor.visiting_fragment_definition?
      # We don't visit if the field is not being used
      return if visitor.skipping?
      # If not a connection or custom type, we can skip.
      return unless allowed_type?(node, visitor.field_definition)

      current_node = node_type(node, visitor)

      # This will actually raise an error if invalid.
      # We need to capture and store that to send back later.
      begin
        current_node.valid?
      rescue GraphQL::AnalysisError => e
        @errors << e
      end

      parent_type = visitor.parent_type_definition
      field_key = node.alias || node.name
      # Find the node_amount for this field --
      # if we're re-entering a selection, we'll already have one.
      # Otherwise, make a new one and store it.
      #
      # `node` and `visitor.field_definition` may appear from a cache,
      # but I think that's ok. If the arguments _didn't_ match,
      # then the query would have been rejected as invalid.
      nodes_on_type = @nodes_on_type_by_query[visitor.query] ||= [
        BaseScopeType.new(query)
      ]

      current_node = nodes_on_type.last
                                  .scoped_children[parent_type][field_key] ||= current_node
      # Push it on the stack.
      nodes_on_type.push(current_node)
    end

    def on_leave_field(node, _parent, visitor)
      # We don't want to visit fragment definitions,
      # we'll visit them when we hit the spreads instead
      return if visitor.visiting_fragment_definition?
      # We don't visit if the field is not being used
      return if visitor.skipping?
      # If not a connection or custom type, we can skip.
      return unless allowed_type?(node, visitor.field_definition)

      nodes_on_type = @nodes_on_type_by_query[visitor.query]
      nodes_on_type.pop
    end

    private

    # @return [Integer]
    def max_possible_nodes
      @max_possible_nodes ||= @nodes_on_type_by_query.reduce(0) do |total, (_query, nodes_on_type)|
        root_node = nodes_on_type.last
        # Use this entry point to calculate the total node amounts
        total_nodes_amount_for_query = merged_node_amounts_for_scopes([
          root_node.scoped_children
        ])

        total + total_nodes_amount_for_query
      end
    end

    # We are checking if a field is a connection or custom type
    def allowed_type?(node, field_definition)
      return true if field_definition.connection?
      return false if field_definition.name == 'nodes'
      # I am not sure if there is a better way to identify these.
      # but this will get the custom type
      return true if node.children.present?

      false
    end

    def node_type(node, visitor)
      prefix = visitor.field_definition.connection? ? 'Connection' : 'Custom'

      "Analysis::MaxNodeLimit::#{prefix}ScopeType".safe_constantize.new(
        visitor.query,
        node: node,
        field_definition: visitor.field_definition
      )
    end

    def merged_node_amounts_for_scopes(scoped_children_hashes, total = 0)
      scoped_children_array = []

      scoped_children_hashes.each do |scoped_children_hash|
        scoped_children_hash.each_value do |children_hash|
          scoped_children_array.concat(children_hash.values)
        end
      end

      merged_node_limit(scoped_children_array, total)
    end

    def merged_node_limit(scoped_children, total)
      current_total = 0

      scoped_children.each do |child|
        if child.terminal?
          current_total += child.total_nodes(total)
        else
          child_nodes = merged_node_amounts_for_scopes(
            Array.wrap(child.scoped_children),
            total
          )

          current_total += child.total_nodes(child_nodes)
        end
      end

      current_total
    end

    def max_possible_nodes_limit_error
      message = "Your request of #{max_possible_nodes} exceeds the node limit: #{NODE_LIMIT}"
      GraphQL::AnalysisError.new(message)
    end
  end
end
