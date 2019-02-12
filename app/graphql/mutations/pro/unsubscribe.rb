class Mutations::Pro::Unsubscribe < Mutations::BaseMutation
  field :expires_at, GraphQL::Types::ISO8601DateTime, null: true

  def ready?
    raise GraphQL::ExecutionError, 'Must be logged in' if user.blank?
    raise GraphQL::ExecutionError, 'No subscription found' if subscription.blank?

    true
  end

  def resolve
    user = context[:user]
    subscription = user.pro_subscription

    subscription.cancel!

    { expires_at: user.pro_expires_at }
  rescue ProSubscription::NoCancellationError
    raise GraphQL::ExecutionError, 'Cannot cancel an iOS subscription'
  end

  private

  def user
    context[:user]
  end

  def subscription
    user.pro_subscription
  end
end
