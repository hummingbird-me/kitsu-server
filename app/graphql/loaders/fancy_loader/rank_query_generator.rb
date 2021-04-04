# @private
class Loaders::FancyLoader::RankQueryGenerator
  # @param key [Symbol] The table row key
  # @param partition_key [Symbol] The find_by key for the table
  # @param table [Arel::Table]
  def initialize(key, partition_key, table)
    @key = key
    @partition_key = partition_key
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
    "#{@key}_rank"
  end

  def partition
    @partition ||= Arel::Nodes::Window.new.partition(@table[@partition_key]).order(order)
  end

  def order
    @table[@key].asc
  end
end
