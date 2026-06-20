module GraphQL
  class FancyLoader < GraphQL::Batch::Loader
    module DSL
      extend ActiveSupport::Concern

      included do
        class_attribute :model
        class_attribute :sorts
        class_attribute :modify_query_lambda
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

        def modify_query(lambda)
          self.modify_query_lambda = lambda
        end
      end
    end
  end
end
