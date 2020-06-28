class Mutations::BaseMutation < GraphQL::Schema::Mutation
  include BehindFeatureFlag
  include CustomPayloadType

  def authorize(record, method)
    return if Pundit.policy!(context[:token], record).public_send(method)

    raise Errors::NotAuthorized, "You don't have permission to do that"
  end
end
