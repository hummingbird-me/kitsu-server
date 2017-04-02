# Base class for all SearchServices.  Abstracts away all the details of managing
# a query so the subclasses can focus on just building a solid query.
#
# @abstract
class SearchService
  include DSL

  # Builds the query to be used by {#total_count} and {#to_a}
  #
  # @abstract Subclass is expected to implement #query_results
  # @return [Chewy::Query, #total_count, #to_a] the built query object
  def query_results
    raise NotImplementedError
  end

  # Returns the total number of matching results for the query and filters
  #
  # @return [Integer] the total number of results
  def total_count
    query_results.total_count
  end

  # Collapse the waveform, run the filters and queries, and return the result
  # as an array.
  #
  # @return [Array<ActiveModel>] the results of the search, in ActiveModel form
  def to_a
    query_results.to_a
  end

  private

  # Generate an "automatic" query for the field and value.  This only really
  # works for obvious cases, generally creating a filter that is equivalent to
  # what ActiveRecord would have created.
  #
  # @param [String] field the key of the field
  # @param [Object] value the value to generate a query for
  # @return [Hash] the resulting query object
  def auto_query_for(field, value)
    case value
    when String, Numeric, Date
      { match: { field => value } }
    when Range
      { range: { field => { gte: value.min, lte: value.max } } }
    when Array
      # Array<String|Fixnum|Float> get shorthanded to a single match query
      if value.all? { |v| v.is_a?(String) || v.is_a?(Numeric) }
        auto_query_for(field, value.join(' '))
      else
        matchers = value.map { |v| auto_query_for(field, v) }
        { bool: { should: matchers } }
      end
    when Hash
      value.deep_transform_keys { |key| key.to_s == '$field' ? field : key }
    else
      value
    end
  end

  # Apply a list of filters to a Chewy::Query or other object which responds to
  # #filter which are automatically generated based on the array of hashes.
  #
  # @param [Chewy::Query, #filter] query the object to perform a query on
  # @param [Array<Hash>] filters the filters to apply
  def apply_auto_filters_to(query, filters = _filters)
    filters.reduce(query) do |acc, (field, value)|
      acc.filter(auto_query_for(field, value))
    end
  end

  # Apply the limit (mostly included for parity with other properties)
  #
  # @param [#limit] query the target to apply the limit to
  def apply_limit_to(query)
    return query unless _limit
    query.limit(_limit)
  end

  # Apply the offset (mostly included for parity with other properties)
  #
  # @param [#offset] query the target to apply the offset to
  def apply_offset_to(query)
    return query unless _offset
    query.offset(_offset)
  end

  # Apply the order (mostly included for parity with other properties)
  #
  # @param [#order] query the target to apply the order to
  def apply_order_to(query)
    return query unless _order
    query.order(_order)
  end

  # Apply the includes, using ActiveRecord-style #includes if the target
  # implements it, otherwise using Chewy-style #load
  #
  # @param [#includes, #load] query the target to apply the includes to
  def apply_includes_to(query)
    return query unless _includes
    if query.respond_to?(:includes) # ActiveRecord
      query.includes(_includes)
    else # Chewy
      query.load(scope: -> { includes(_includes) })
    end
  end
end
