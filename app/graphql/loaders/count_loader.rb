class Loaders::CountLoader < GraphQL::Batch::Loader
  def initialize(model, field)
    @model = model
    @field = field
  end

  def perform(keys)
    counts = @model.where(@field => keys).group(@field).count
    keys.each do |key|
      fulfill(key, counts[key] || 0)
    end
  end
end
