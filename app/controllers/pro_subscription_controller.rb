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
  rescue Stripe::CardError
    render_jsonapi_error 400, 'Invalid card'
  rescue Stripe::APIConnectionError
    render_jsonapi_error 502, 'Failed to connect to credit card processor'
  rescue Stripe::StripeError
    render_jsonapi_error 500, 'Something went wrong with our credit card processor'
  end

  def ios
    receipt = AppleReceiptService.new(params[:receipt])
    ProSubscription::AppleSubscription.create!(user: user, billing_id: receipt.billing_id)
    render status: 200
  rescue AppleReceiptService::Error::ServerUnavailable, AppleReceiptService::Error::InternalError
    render_jsonapi_error 502, 'Failed to connect to Apple App Store'
  rescue AppleReceiptService::Error::MalformedReceipt,
         AppleReceiptService::Error::TestReceiptOnProduction,
         AppleReceiptService::Error::ProductionReceiptOnTest
    render_jsonapi_error 400, 'Receipt data was malformed'
  rescue AppleReceiptService::Error::InvalidSecret, AppleReceiptService::Error::InvalidJSON
    render_jsonapi_error 500, 'Something went wrong when validating with the Apple App Store'
  rescue AppleReceiptService::Error
    render_jsonapi_error 402, 'An unknown error occurred'
  end

  def destroy
    case user.pro_subscription.billing_service
    when :apple_ios
      # We cannot cancel an iOS subscription — cancellation must be done through Apple or in-app
      render_jsonapi_error 400, 'Cannot cancel an iOS subscription outside of the App Store'
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
