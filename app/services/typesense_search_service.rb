# frozen_string_literal: true

# Provides a helpful base class for search services backed by typesense.
#
# @abstract
class TypesenseSearchService < SearchService
  def total_count
    query_results.count
  end

  private

  def apply_auto_filter_for(scope, field, filter_param: field)
    if filters[filter_param]
      scope.filter(auto_query_for(field, filters[filter_param]))
    else
      scope
    end
  end

  def auto_query_for(field, value)
    case value
    when Range
      if value.begin.nil?
        { field => "<#{value.max}" }
      elsif value.end.nil?
        { field => ">=#{value.min}" }
      else
        { field => "[#{value.min}..#{value.max}]" }
      end
    when Array
      { field => "=[#{value.join(',')}]" }
    when Date
      { field => "=#{value.to_time.to_i}" }
    else
      { field => "=#{value}" }
    end
  end

  def apply_order_to(scope)
    scope.sort(orders)
  end

  def apply_limit_to(scope)
    return scope unless _limit

    scope.per(_limit)
  end

  def apply_offset_to(scope)
    return scope unless _offset

    scope.page((_offset / _limit).floor)
  end

  def orders
    @orders ||=
      _order
      &.map { |o| o.transform_keys { |k| k == '_score' ? '_text_match' : k } }
      &.reduce(&:merge)
  end

  # Combine the queries and filters into a single hash
  def filters
    @filters ||= _filters.merge(_queries)
  end
end
