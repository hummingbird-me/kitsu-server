# @private
class Loaders::FancyLoader::RankQueryGenerator
  # @param column [Symbol] The table column to rank by
  # @param partition_by [Symbol] The find_by key for the table
  # @param table [Arel::Table]
  def initialize(column:, partition_by:, table:)
    @column = column
    @partition_by = partition_by
    @table = table
  end

  # Our actual window function.
  #
  #   ROW_NUMBER() OVER (#{partition})
  def arel
    Arel::Nodes::NamedFunction.new('ROW_NUMBER', []).over(partition).as(name)
  end

  private

  def name
    "#{@column}_rank"
  end

  def partition
    @partition ||= Arel::Nodes::Window.new.partition(@table[@partition_by]).order(order)
  end

  def order
    @table[@column].asc
  end
end
