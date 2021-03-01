class Loaders::FancyLoader::PaginationFilter
  def initialize(query, before: nil, after: nil, first: nil, last: nil)
    @query = query
    @before = before
    @after = after
    @first = first
    @last = last
  end

  def arel
    [
      after_filter,
      before_filter,
      first_filter,
      last_filter
    ].compact.inject(&:and)
  end

  private

  def row
    @row ||= @query[:row_number]
  end

  def count
    @count ||= @query[:total_count]
  end

  def after_filter
    return unless @after

    row.gt(@after)
  end

  def before_filter
    return unless @before

    row.lt(@before)
  end

  def first_filter
    return unless @first

    if @after
      row.lteq(@after + @first)
    else
      row.lteq(@first)
    end
  end

  def last_filter
    return unless @last

    if @before
      row.gteq(@before - @last)
    else
      row.gt(Arel::Nodes::Subtraction.new(count, @last))
    end
  end
end
