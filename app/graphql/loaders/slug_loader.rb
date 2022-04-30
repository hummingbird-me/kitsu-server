class Loaders::SlugLoader < Loaders::RecordLoader
  def initialize(model, column: :slug, **args)
    super(model, column: column, **args)
  end

  def cache_key(load_key)
    load_key.downcase
  end
end
