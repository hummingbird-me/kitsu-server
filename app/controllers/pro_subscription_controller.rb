class ProSubscriptionController < ApplicationController
  include CustomControllerHelpers

  before_action :check_feature_flag!
  before_action :authenticate_user!

  def stripe
    customer = user.stripe_customer
    customer.source = params[:token]
    customer.save
    render json: ProSubscription::StripeSubscription.create!(user: user)
  rescue Stripe::CardError
    render_jsonapi_error 400, 'Invalid card'
  rescue Stripe::APIConnectionError
    render_jsonapi_error 502, 'Failed to connect to credit card processor'
  rescue Stripe::StripeError
    render_jsonapi_error 500, 'Something went wrong with our credit card processor'
  end

  def ios
    receipt = AppleReceiptService.new(params[:receipt])
    render json: ProSubscription::AppleSubscription.create!(
      user: user,
      billing_id: receipt.billing_id
    )
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

  def google_play
    token = params[:token]
    subscription = GooglePlaySubscriptionService.new(token)
    subscription.validate!
    render json: ProSubscription::GooglePlaySubscription.create!(user: user, billing_id: token)
  rescue Google::Apis::ClientError
    render_jsonapi_error 400, 'Google Play returned a client error'
  rescue Google::Apis::ServerError
    render_jsonapi_error 502, 'Something went wrong when validating with Google Play'
  end

  def destroy
    case user.pro_subscription.billing_service
    when :apple_ios
      # We cannot cancel an iOS subscription — cancellation must be done through Apple or in-app
      render_jsonapi_error 400, 'Cannot cancel an iOS subscription outside of the App Store'
    when :stripe, :google_play
      user.pro_subscription.destroy!
      render json: {}
    end
  end

  def show
    if user.pro_subscription.present?
      render json: user.pro_subscription
    else
      render status: 404, json: {}
    end
  end

  private

  def check_feature_flag!
    render status: 404, json: {} unless Flipper[:pro_subscriptions].enabled?(user)
  end

  def user
    current_user.resource_owner
  end
end
