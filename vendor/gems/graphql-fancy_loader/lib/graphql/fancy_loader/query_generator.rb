# @private
module GraphQL
  class FancyLoader
    class QueryGenerator
      # @param model [ActiveRecord::Model] the model to load from
      # @param find_by [Symbol, String, Array<Symbol, String>] the key or keys to find by
      # @param sort [Array<{:column, :transform, :direction => Object}>] The sorts to apply
      # @param keys [Array] an array of values to find by
      # @param before [Integer] Filter by rows less than this (one-indexed)
      # @param after [Integer] Filter by rows greater than this (one-indexed)
      # @param first [Integer] Filter for first N rows
      # @param last [Integer] Filter for last N rows
      # @param where [Hash] a filter to use when querying
      # @param context [Context] The context of the graphql query. Can be used inside of modify_query.
      # @param modify_query [Lambda] An escape hatch to FancyLoader to allow modifying
      #  the base_query before it generates the rest of the query
      def initialize(
        model:, find_by:, sort:, keys:,
        before: nil, after: 0, first: nil, last: nil,
        where: nil, context: {}, modify_query: nil
      )
        @model = model
        @find_by = find_by
        @sort = sort
        @keys = keys
        @before = before
        @after = after
        @first = first
        @last = last
        @where = where
        @context = context
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

      attr_reader :context

      # The underlying Arel table for the model
      def table
        @table ||= @model.arel_table
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
        @pagination_filter ||= GraphQL::FancyLoader::PaginationFilter.new(
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
        query = middleware(query: query)
        query.arel
      end

      def subquery
        @subquery ||= begin
          # Apply the sort transforms and add the window function to our projection
          subquery = @sort.inject(base_query) do |arel, sort|
            sort[:transform] ? sort[:transform].call(arel, context) : arel
          end

          subquery = subquery.project(row_number).project(count)
          subquery = instance_exec(subquery, &@modify_query) unless @modify_query.nil?
          subquery.as('subquery')
        end
      end

      def middleware(query:)
        return query if GraphQL::FancyLoader.middleware.blank?

        GraphQL::FancyLoader.middleware.each do |klass|
          query = klass.call(model: @model, query: query, context: context)
        end

        query
      end
    end
  end
end
