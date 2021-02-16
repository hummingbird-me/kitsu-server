class Mutations::Pro::Unsubscribe < Mutations::Base
  field :expires_at, GraphQL::Types::ISO8601DateTime, null: true

  def ready?
    raise GraphQL::ExecutionError, 'Must be logged in' if user.blank?

    true
  end

  def resolve(reason: nil)
    Pro::Unsubscribe.call(
      user: context[:user],
      reason: reason
    )
  rescue ProSubscription::NoCancellationError
    raise GraphQL::ExecutionError, 'Cannot cancel that type of subscription here'
  end
end
