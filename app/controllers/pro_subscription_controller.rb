class ProSubscriptionController < ApplicationController
  include CustomControllerHelpers

  before_action :authenticate_user!

  def stripe
    token = params[:token]
    customer = Stripe::Customer.create(source: token, email: user.email)
    subscription = Stripe::Subscription.create(
      customer: customer.id,
      items: [
        { plan: 'pro-yearly' }
      ]
    )
    # TODO: add a response
  end

  def ios
    # TODO: read iOS receipt and store enough data to verify with App Store servers
  end

  def destroy
    # TODO: read the pro subscription info and destroy it
  end

  def show
    # TODO: return the pro subscription
  end

  private

  def user
    current_user.resource_owner
  end
end
