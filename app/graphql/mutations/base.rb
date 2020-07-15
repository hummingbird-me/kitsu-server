class Mutations::Base < GraphQL::Schema::Mutation
  include BehindFeatureFlag
  include CustomPayloadType

  def authorized?(record, action)
    return true if Pundit.policy!(context[:token], record).public_send(action)
    return false, Errors::Pundit::NotAuthorizedError.graphql_error
  end
end
