class Mutations::Base < GraphQL::Schema::Mutation
  include BehindFeatureFlag
  include CustomPayloadType

  def authorized?(record, action)
    return true if Pundit.policy!(context[:token], record).public_send(action)

    [false, Errors::Pundit::NotAuthorizedError.graphql_error]
  end

  def current_user
    User.current
  end
end
