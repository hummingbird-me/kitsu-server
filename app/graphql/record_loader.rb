class RecordLoader < GraphQL::Batch::Loader
  def initialize(model)
    @model = model
  end

  def sort_load_many(ids, sort: nil)
    load_many(ids).then do |results|
      sort_results(results, sort)
    end
  end

  def perform(ids)
    @model.where(id: ids).each { |record| fulfill(record.id, record) }

    ids.each do |id|
      next if fulfilled?(id)

      fulfill(id, nil)
    end
  end

  def sort_results(results, sorts)
    return results if sorts.blank?

    formatted_sort = sorts.each_with_object({}) do |sort, hash|
      hash[sort.field] = sort.direction
      hash
    end

    results.order(**formatted_sort)
  end
end
