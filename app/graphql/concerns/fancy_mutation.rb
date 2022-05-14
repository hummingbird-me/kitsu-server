module FancyMutation
  extend ActiveSupport::Concern

  class_methods do
    def result(type, **kwargs)
      field :result, type, **kwargs
    end

    def input(&block)
      input_name = "#{graphql_name}Input"
      input = Class.new(Types::Input::Base) do
        graphql_name input_name
        instance_eval(&block)
      end
      argument :input, input, required: true
    end

    def errors(*types)
      union_name = "#{graphql_name}ErrorsUnion"
      union = Class.new(Types::Union::Base) do
        graphql_name union_name
        possible_types(*types)

        def self.resolve_type(object, _context)
          object.key?(:__type) ? object[:__type] : super
        end
      end
      field :errors, [union], null: true
    end

    def warnings(*types)
      union_name = "#{graphql_name}WarningsUnion"
      union = Class.new(Types::Union::Base) do
        graphql_name union_name
        possible_types types.flatten
      end
      field :errors, [union], null: true
    end
  end

  def resolve_with_support(ignore_warnings: false, **args)
    result = super(**args)

    raise ActiveRecord::Rollback if warnings.present? && !ignore_warnings

    {
      # If the mutation returns the errors list, ignore it (it's not the actual result)
      result: (result unless result == errors),
      warnings: warnings,
      errors: errors
    }
  end

  def errors
    @errors ||= []
  end

  def warnings
    @warnings ||= []
  end
end
