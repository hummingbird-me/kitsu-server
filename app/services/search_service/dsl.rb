# Provides the DSL-like interactive query methods for SearchServices
class SearchService
  module DSL
    extend ActiveSupport::Concern

    # @!attribute [r] _queries
    #   @return [Hash] the queries to apply
    # @!attribute [r] _filters
    #   @return [Hash] the filters to apply
    # @!attribute [r] _includes
    #   @return [Array<Hash, Symbol, String>] the fields to include in AR form
    # @!attribute [r] _order
    #   @return [Array<Hash>] the sort orders in form of { field => direction }
    # @!attribute [r] _offset
    #   @return [Integer] the offset for pagination
    # @!attribute [r] _limit
    #   @return [Integer] the number of items to return on this page
    attr_reader :_queries, :_filters, :_includes, :_order, :_offset, :_limit

    # Set up a Search with queries and filters to be applied to the request
    #
    # @param [Hash] queries the queries to run
    # @param [Hash] fitlers the filters to apply
    def initialize(queries, filters)
      @_queries = queries
      @_filters = filters
      @_includes = []
      @_order = []
    end

    # Add an inclusion declaration to be applied on load. See
    # ActiveRecord::Relation#includes
    #
    # @param [Array<Hash, Symbol, String>] *includes the associations to load
    def includes(*includes)
      @_includes += includes.flatten
      self
    end

    # Add a sort order to be applied on load.  See ActiveRecord::Relation#order
    #
    # @param [Array<String, Symbol, Hash>] *order the orders to apply
    def order(*order)
      @_order += order.flatten
      self
    end

    # Set the offset to be used for pagination.
    #
    # @param [Integer] the offset for pagination
    def offset(offset)
      @_offset = offset
      self
    end

    # Set the number of items to return on this page
    #
    # @param [Integer] the number of items to return on this page
    def limit(limit)
      @_limit = limit
      self
    end
  end
end
