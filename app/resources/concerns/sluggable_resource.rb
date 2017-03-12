module SluggableResource
  extend ActiveSupport::Concern

  included do
    attribute :slug
    filter :slug, apply: ->(records, value, _options) { records.by_slug(value) }
  end
end
