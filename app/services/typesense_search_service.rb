# frozen_string_literal: true

# Provides a helpful base class for search services backed by typesense.
#
# @abstract
class TypesenseSearchService < SearchService
  # This regex accepts a numerical range or single number
  # $1 = start, $2 = dot representing closed/open, $3 = end
  NUMBER = /(\d+(?:\.\d+)?)/
  NUMERIC_RANGE = /\A#{NUMBER}?(\.{2,3})?#{NUMBER}?\z/

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
    value = value.first if value.is_a?(Array) && value&.count == 1

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

  def apply_numeric_filter_for(scope, field, filter_param: field)
    if filters[filter_param]
      value = parse_range(filters[filter_param].first)
      scope.filter(auto_query_for(field, value))
    else
      scope
    end
  end

  def apply_order_to(scope)
    scope.sort(orders)
  end

  def apply_per_to(scope)
    return scope unless _per

    scope.per(_per)
  end

  def apply_page_to(scope)
    return scope unless _page

    scope.page(_page)
  end

  def parse_range(value)
    matches = NUMERIC_RANGE.match(value)
    return if matches.nil?
    # You gotta provide at least *one* number
    return if matches[1].blank? && matches[3].blank?
    inclusive = matches[2] == '..'

    if matches[2] # Range
      Range.new(parse_number(matches[1]), parse_number(matches[3]), !inclusive)
    else # Scalar
      parse_number(matches[1])
    end
  end

  def parse_number(value)
    return if value.nil?
    value.include?('.') ? value.to_f : value.to_i
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

  def _per
    if @_per
      @_per
    elsif @_limit
      @_per = @_limit
    end
  end

  def _page
    if @_page
      @_page
    elsif @_offset && @_limit
      @_page = (@_offset / @_limit).floor
    end
  end
end
