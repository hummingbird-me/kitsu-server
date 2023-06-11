# frozen_string_literal: true

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

  class WarningsPresent < StandardError; end

  class ErrorWrapper < StandardError
    attr_reader :error

    def initialize(error)
      super
      @error = error
    end
  end

  module PrependedMethods
    # Wraps the resolve method with some support. When ignore_warnings is false or not set, it will
    # rollback when there are warnings. In all cases, the return value of the resolve method will be
    # wrapped as the :result field, so that the mutation always returns the correct structure. When
    # the return value is the errors list, we ignore it, so that we won't accidentally try to treat
    # it as the result type.
    # @param ignore_warnings [Boolean] Whether to ignore warnings or not
    def resolve(input:, ignore_warnings: false)
      # Wrap the mutation in a transaction to allow for rollback if there are warnings
      ApplicationRecord.transaction(requires_new: true) do
        result = super(**input)

        # Trigger a rollback but allow us to catch it afterwards and control our response format.
        raise WarningsPresent if warnings.present? && !ignore_warnings

        {
          # If the mutation returns the errors list, ignore it (it's not the actual result)
          result: (result unless result == errors),
          warnings:,
          errors:
        }
      end
    rescue WarningsPresent
      {
        warnings:,
        errors: [*errors, Types::Errors::WarningsPresent.build]
      }
    rescue ErrorWrapper => e
      { errors: [*errors, e.error] }
    end

    # The return-driven approach of #ready? and #authorized? is garbage, so we override it and allow
    # using the same error system as in #resolve. To achieve this, we prepend a module wrapping the
    # mutation's #ready? and #authorized? methods, detecting the state of the error object after
    # execution and changing the result if needed.
    def ready?(input:)
      ready, result = super(**input)

      return [false, { errors: }] if errors.present?

      [ready, result]
    rescue ErrorWrapper => e
      [false, { errors: [*errors, e.error] }]
    end

    def authorized?(input:)
      ready, result = super(**input)

      return [false, { errors: }] if errors.present?

      [ready, result]
    rescue ErrorWrapper => e
      [false, { errors: [*errors, e.error] }]
    end
  end

  class_methods do
    # Sets the result type
    # @param type [Class] The GraphQL type to use for the result
    def result(type, **kwargs)
      field :result, type, **kwargs
    end

    # Sets up an input type and field for the mutation
    # @param block [Proc] A block defining the input type fields
    def input(&)
      input_type.instance_eval(&)
    end

    # Adds types to the union of error types for the mutation
    # @param types [Array<Class>] The error types this can return
    def errors(*types)
      errors_union.possible_types(*types)
    end

    # Adds types to the union of warning types for the mutation
    # @param types [Array<Class>] The warning types this can return
    def warnings(*types)
      warnings_union.possible_types(*types)
    end

    ### private_class_methods ###

    # These methods are kinda strange. The first time they're called, they create a new type, hook
    # it up to the mutation, and return it. When they get called again, they return that same type,
    # allowing us to modify them repeatedly from different locations. This allows utilities to add
    # types automatically such as an ignore_warnings argument, or a common error type.
    def errors_union
      @errors_union ||= begin
        union_name = "#{graphql_name}ErrorsUnion"
        errors_union = Class.new(Types::Union::Base) do
          graphql_name union_name

          def self.resolve_type(object, _context)
            object.key?(:__type) ? object[:__type] : super
          end
        end
        field :errors, [errors_union], null: true

        errors_union
      end
    end

    def warnings_union
      @warnings_union ||= begin
        union_name = "#{graphql_name}WarningsUnion"
        warnings_union = Class.new(Types::Union::Base) do
          graphql_name union_name

          def self.resolve_type(object, _context)
            object.key?(:__type) ? object[:__type] : super
          end
        end
        field :warnings, [warnings_union], null: true

        # Add the ignore_warnings argument and error type
        input { argument :ignore_warnings, GraphQL::Types::Boolean, required: false }
        errors Types::Errors::WarningsPresent

        warnings_union
      end
    end

    def input_type
      @input_type ||= begin
        input_name = "#{graphql_name}Input"
        input_type = Class.new(Types::Input::Base) do
          graphql_name input_name
        end
        argument :input, input_type, required: true

        input_type
      end
    end
  end

  included do
    prepend PrependedMethods
    private_class_method :errors_union
    private_class_method :warnings_union
    private_class_method :input_type
  end

  # Raises an error if there is no current user session.
  def authenticate!
    raise Types::Errors::NotAuthenticated if current_user.blank?
    true
  end

  # Raises an error if the current user is not authorized to perform the action on the object.
  # @param object [ActiveRecord::Base] The object to check authorization on
  # @param action [Symbol] The action to check authorization for
  def authorize!(object, action, policy: Pundit::PolicyFinder.new(object).policy)
    authorized = policy.new(current_token, object).public_send(action)
    raise Types::Errors::NotAuthorized, { object:, action: } unless authorized
    true
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
