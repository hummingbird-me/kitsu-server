class Loaders::FancyLoader < GraphQL::Batch::Loader
  class_attribute :model
  class_attribute :sorts

  class << self
    def from(model)
      self.model = model
    end

    def sort(name, transform: nil, on: -> { model.arel_table[name] })
      self.sorts ||= {}
      sorts[name] = {
        transform: transform,
        column: on
      }
    end
  end

  def initialize(find_by:, limit:, offset: 0, order:, token:)
    @find_by = find_by
    @limit = limit
    @offset = offset
    @order = order
    @token = token
  end

  def perform(keys)
    # First, we do our ActiveRecord::Relation stuff
    query = model.where(@find_by => keys)
    query = scope.new(@token, query).resolve

    # Then we drop down into Arel for the fun part!
    query_arel = query.arel
    table = query.arel_table

    # Apply the transform and column lambdas for the sorting requested
    query_arel = @order.keys.inject(query_arel) do |arel, key|
      if sorts[key][:transform]
        sorts[key][:transform].call(arel)
      else
        arel
      end
    end
    orders = @order.map do |key, direction|
      sorts[key][:column].call.public_send(direction)
    end

    # Build up a window function with the sorting applied
    partition = Arel::Nodes::Window.new
                                   .partition(table[@find_by])
                                   .order(orders)
    row_number = Arel::Nodes::NamedFunction.new('ROW_NUMBER', [])
                                           .over(partition)
                                           .as('row_number')

    # Select the row number, shove it into a subquery, then set up our offset and limit
    query_arel.project(row_number)
    subquery = query_arel.as('subquery')
    offset = subquery[:row_number].gt(@offset)
    limit = subquery[:row_number].lteq(@offset + @limit)

    # Finally, go *back* to the ActiveRecord model, and do the final select
    records = model.select(Arel.star).from(subquery).where(offset.and(limit)).to_a
    results = records.group_by { |rec| rec[@find_by] }
    keys.each do |key|
      fulfill(key, results[key] || [])
    end
  end

  private



  def scope
    @scope ||= Pundit::PolicyFinder.new(model).scope!
  end
end
