module Loaders::FancyLoader::DSL
  extend ActiveSupport::Concern

  included do
    class_attribute :model
    class_attribute :sorts
  end

  class_methods do
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
end
