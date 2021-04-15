# @private
class Loaders::FancyLoader::QueryGenerator
  # @param model [ActiveRecord::Model] the model to load from
  # @param find_by [Symbol, String, Array<Symbol, String>] the key or keys to find by
  # @param sort [Array<{:column, :transform, :direction => Object}>] The sorts to apply
  # @param token [Doorkeeper::AccessToken] the user's access token
  # @param keys [Array] an array of values to find by
  # @param before [Integer] Filter by rows less than this (one-indexed)
  # @param after [Integer] Filter by rows greater than this (one-indexed)
  # @param first [Integer] Filter for first N rows
  # @param last [Integer] Filter for last N rows
  # @param where [Hash] a filter to use when querying
  # @param modify_query [Lambda] An escape hatch to FancyLoader to allow modifying
  #  the base_query before it generates the rest of the query
  def initialize(
    model:, find_by:, sort:, token:, keys:,
    before: nil, after: 0, first: nil, last: nil,
    where: nil, modify_query: nil
  )
    @model = model
    @find_by = find_by
    @sort = sort
    @token = token
    @keys = keys
    @before = before
    @after = after
    @first = first
    @last = last
    @where = where
    @modify_query = modify_query
  end

  def query
    # Finally, go *back* to the ActiveRecord model, and do the final select
    @model.unscoped
          .select(Arel.star)
          .from(subquery)
          .where(pagination_filter(subquery))
          .order(subquery[:row_number].asc)
  end

  private

  # The underlying Arel table for the model
  def table
    @table ||= @model.arel_table
  end

  # A pundit scope class to apply to our querying
  def scope
    @scope ||= Pundit::PolicyFinder.new(@model).scope!
  end

  # A window function partition clause to apply the sort within each window
  #
  #   PARTITION BY #{find_by} ORDER BY #{orders}
  def partition
    @partition ||= begin
      # Every sort has a column and a direction, apply them
      orders = @sort.map do |sort|
        sort[:column].call.public_send(sort[:direction])
      end

      Arel::Nodes::Window.new.partition(table[@find_by]).order(orders)
    end
  end

  # Our actual window function.
  #
  #   ROW_NUMBER() OVER (#{partition})
  def row_number
    Arel::Nodes::NamedFunction.new('ROW_NUMBER', []).over(partition).as('row_number')
  end

  # A count window function. Omits sort from the partition to get the total count.
  #
  #   COUNT(*) OVER (#{partition})
  def count
    count_partition = Arel::Nodes::Window.new.partition(table[@find_by])
    Arel::Nodes::NamedFunction.new('COUNT', [Arel.star]).over(count_partition).as('total_count')
  end

  def pagination_filter(query)
    @pagination_filter ||= Loaders::FancyLoader::PaginationFilter.new(
      query,
      before: @before,
      after: @after,
      first: @first,
      last: @last
    ).arel
  end

  # The "base" query. This is the query that would load everything without pagination or sorting,
  # just auth scoping.
  def base_query
    query = @model.where(@find_by => @keys)
    query = query.where(@where) unless @where.nil?
    scope.new(@token, query).resolve.arel
  end

  def subquery
    @subquery ||= begin
      # Apply the sort transforms and add the window function to our projection
      subquery = @sort.inject(base_query) do |arel, sort|
        sort[:transform] ? sort[:transform].call(arel) : arel
      end

      subquery = subquery.project(row_number).project(count)
      subquery = instance_exec(subquery, &@modify_query) unless @modify_query.nil?
      subquery.as('subquery')
    end
  end
end
