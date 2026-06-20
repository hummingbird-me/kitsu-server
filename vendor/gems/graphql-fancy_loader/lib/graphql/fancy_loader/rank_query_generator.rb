# @private
module GraphQL
  class FancyLoader
    class RankQueryGenerator
      # @param column [Symbol] The table column to rank by
      # @param partition_by [Symbol] The find_by key for the table
      # @param table [Arel::Table]
      # @param name_suffix [String] The suffix the be used for the column name
      def initialize(column:, partition_by:, table:, name_suffix: '_rank')
        @column = column
        @partition_by = partition_by
        @table = table
        @name_suffix = name_suffix
      end

      # Our actual window function.
      #
      #   ROW_NUMBER() OVER (#{partition})
      def arel
        Arel::Nodes::NamedFunction.new('ROW_NUMBER', []).over(partition).as(name)
      end

      private

      def name
        return @column if @name_suffix.blank?

        "#{@column}#{@name_suffix}"
      end

      def partition
        @partition ||= Arel::Nodes::Window.new.partition(@table[@partition_by]).order(order)
      end

      def order
        @table[@column].asc
      end
    end
  end
end
