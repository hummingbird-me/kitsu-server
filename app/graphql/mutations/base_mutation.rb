class Mutations::BaseMutation < GraphQL::Schema::Mutation
  include BehindFeatureFlag
  include CustomPayloadType

  def authorize(model, method)
    return if Pundit.policy!(context[:token], model).public_send(method)

    raise GraphQL::ExecutionError, "You don't have permission to do that"
  end
end
