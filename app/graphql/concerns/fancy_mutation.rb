# Provides a bunch of helpers for our standard mutation structure, making consistency easy!
#
# @example
#   class Mutations::Post::Like < Mutations::Base
#     # Pass a description here to be used in the GraphQL schema
#     description 'Like a post'
#     # Build your input type here (set arguments)
#     input do
#       argument :postId, ID,
#         required: true,
#         description: 'The post to like'
#     end
#     # Your result type should generally expose what changed so clients can update their cache
#     result Types::Post
#     # Build the union of errors which you may return
#     errors Types::Errors::NotAuthorized,
#       Types::Errors::NotAuthenticated,
#       Types::Errors::Conflict
#
#     def resolve(post_id:)
#       return errors << Types::Errors::NotAuthenticated.build unless context[:current_user]
#       # In most cases you'll want to delegate to a Mutator class so the logic can be unit-tested.
#       PostMutator.like(post: Post.find(post_id), user: context[:current_user])
#     rescue ActiveRecord::RecordInvalid => e
#       errors << Types::Errors::Conflict.build
#     rescue Pundit::NotAuthorizedError => e
#       errors << Types::Errors::NotAuthorized.build
#     end
#   end
module FancyMutation
  extend ActiveSupport::Concern

  class_methods do
    # Sets the result type
    # @param type [Class] The GraphQL type to use for the result
    def result(type, **kwargs)
      field :result, type, **kwargs
    end

    # Sets up an input type and field for the mutation
    # @param block [Proc] A block defining the input type fields
    def input(&block)
      input_name = "#{graphql_name}Input"
      input = Class.new(Types::Input::Base) do
        graphql_name input_name
        instance_eval(&block)
      end
      argument :input, input, required: true
    end

    # Sets up the union of error types for the mutation
    # @param types [Array<Class>] The error types this can return
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

    # Sets up the union of warning types for the mutation
    # @param types [Array<Class>] The warning types this can return
    def warnings(*types)
      union_name = "#{graphql_name}WarningsUnion"
      union = Class.new(Types::Union::Base) do
        graphql_name union_name
        possible_types types.flatten
      end
      field :errors, [union], null: true
    end
  end

  # Wraps the resolve method with some support. When ignore_warnings is false or not set, it will
  # rollback when there are warnings. In all cases, the return value of the resolve method will be
  # wrapped as the :result field, so that the mutation always returns the correct structure. When
  # the return value is the errors list, we ignore it, so that we won't accidentally try to treat it
  # as the result type.
  # @param ignore_warnings [Boolean] Whether to ignore warnings or not
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

  # A list of errors from the mutation. Push to this list from your resolve method.
  def errors
    @errors ||= []
  end

  # A list of warnings from the mutation. Push to this list from your resolve method.
  def warnings
    @warnings ||= []
  end
end
