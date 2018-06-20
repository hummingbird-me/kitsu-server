class ProSubscriptionController < ApplicationController
  include CustomControllerHelpers

  before_action :authenticate_user!

  def stripe
    customer = user.stripe_customer
    customer.source = params[:token]
    customer.save
    ProSubscription::StripeSubscription.create!(user: user)
    render status: 200
  end

  def ios
    receipt = AppleReceiptService.new(params[:receipt])
    ProSubscription::AppleSubscription.create!(user: user, billing_id: receipt.billing_id)
    render status: 200
  rescue AppleReceiptService::Error::ServerUnavailable, AppleReceiptService::Error::InternalError
    render status: 502
  rescue AppleReceiptService::Error::MalformedReceipt,
         AppleReceiptService::Error::TestReceiptOnProduction,
         AppleReceiptService::Error::ProductionReceiptOnTest
    render status: 400
  rescue AppleReceiptService::Error::InvalidSecret, AppleReceiptService::Error::InvalidJSON
    render status: 500
  rescue AppleReceiptService::Error
    render status: 402
  end

  def destroy
    # TODO: read the pro subscription info and destroy it
  end

  def show
    if user.pro_subscription.present?
      render json: {
        service: user.pro_subscription.billing_service,
        plan: 'yearly'
      }
    else
      render status: 404
    end
  end

  private

  def user
    current_user.resource_owner
  end
end
