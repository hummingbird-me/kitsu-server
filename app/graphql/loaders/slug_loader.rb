# frozen_string_literal: true

class Loaders::SlugLoader < Loaders::UnscopedRecordLoader
  def initialize(model, column: :slug, **args)
    super(model, column:, **args)
  end

  def cache_key(load_key)
    load_key.downcase
  end
end
