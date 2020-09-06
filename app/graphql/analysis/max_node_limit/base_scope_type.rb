# frozen_string_literal: true

module Analysis
  class MaxNodeLimit
    class BaseScopeType
      attr_reader :field_definition, :response_path, :query

      delegate :complexity, to: :field_definition

      # A single proc for {#scoped_children} hashes. Use this to avoid repeated allocations,
      # since the lexical binding isn't important.
      HASH_CHILDREN = ->(h, k) { h[k] = {} }

      # @param query [GraphQL::Query] Used for `query.possible_types`
      # @param response_path [Array<String>] The path to the response key for the field
      # @param node [Language::Nodes::Field] The AST node; used for providing argument values when necessary
      # @param field_definition [GraphQL::Field, GraphQL::Schema::Field] Used for getting the `.complexity` configuration
      def initialize(query, response_path, node: nil, field_definition: nil)
        @query = query
        @response_path = response_path
        @node = node
        @field_definition = field_definition

        @scoped_children = nil
      end

      # Returns true if this field has no selections, ie, it's a scalar.
      # We need a quick way to check whether we should continue traversing.
      def terminal?
        @scoped_children.nil?
      end

      # This value is only calculated when asked for to avoid needless hash allocations.
      # Also, if it's never asked for, we determine that this scope complexity
      # is a scalar field ({#terminal?}).
      # @return [Hash<Hash<Class => ScopedTypeComplexity>]
      def scoped_children
        @scoped_children ||= Hash.new(&HASH_CHILDREN)
      end

      def valid?
        true
      end
    end
  end
end
