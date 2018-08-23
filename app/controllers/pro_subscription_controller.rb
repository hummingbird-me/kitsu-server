class ProSubscriptionController < ApplicationController
  include CustomControllerHelpers

  before_action :check_feature_flag!
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
    case user.pro_subscription.billing_service
    when :apple_ios
      # We cannot cancel an iOS subscription — cancellation must be done through Apple or in-app
      render status: 400
    when :stripe
      user.pro_subscription.destroy!
      render status: 200
    end
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

  def check_feature_flag!
    render status: 404 unless Flipper[:pro_subscriptions].enabled?(user)
  end

  def user
    current_user.resource_owner
  end
end
