# @private
class Loaders::FancyLoader::QueryGenerator
  # @param model [ActiveRecord::Model] the model to load from
  # @param find_by [Symbol, String] the key to find by
  # @param limit [Integer] The number of rows to retrieve
  # @param offset [Integer] The offset of the rows to retrieve
  # @param sort [Array<{:column, :transform, :direction => Object}>] The sorts to apply
  # @param token [Doorkeeper::AccessToken] the user's access token
  # @param keys [Array] an array of values to find by
  def initialize(
    model:, find_by:, limit:, offset:, sort:, token:, keys:
  )
    @model = model
    @find_by = find_by
    @limit = limit
    @offset = offset
    @sort = sort
    @token = token
    @keys = keys
  end

  def query
    # Apply the sort transforms and add the window function to our projection
    subquery = @sort.inject(base_query) do |arel, sort|
      sort[:transform] ? sort[:transform].call(arel) : arel
    end
    subquery = subquery.project(row_number).as('subquery')

    # Generate conditions to filter for pagination
    offset = subquery[:row_number].gt(@offset)
    limit = subquery[:row_number].lteq(@offset + @limit)

    # Finally, go *back* to the ActiveRecord model, and do the final select
    @model.select(Arel.star).from(subquery).where(offset.and(limit))
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

  # The "base" query. This is the query that would load everything without pagination or sorting,
  # just auth scoping.
  def base_query
    scope.new(@token, @model.where(@find_by => @keys)).resolve.arel
  end
end
