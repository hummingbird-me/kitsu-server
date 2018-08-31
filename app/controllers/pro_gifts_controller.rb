class ProGiftsController < ApplicationController
  include CustomControllerHelpers

  before_action :check_feature_flag!
  before_action :authenticate_user!

  def create
    to = User.find(params[:to])
    message = params[:message].presence

    case params[:service].downcase
    when 'stripe'
      StripeGiftService.new(from: user, to: to, token: params[:token]).call
      ProGiftService.new(from: user, to: to, message: message).call
    else
      return render_jsonapi_error 400, 'Unknown payment service'
    end

    render status: 200
  rescue ProGiftService::InvalidSelfGift
    render_jsonapi_error 400, 'Cannot gift to self'
  rescue ProGiftService::RecipientIsPro
    render_jsonapi_error 400, 'Cannot gift to a user who already has pro'
  rescue ActiveRecord::RecordNotFound
    render_jsonapi_error 404, 'Recipient not found'
  end

  private

  def check_feature_flag!
    render status: 404 unless Flipper[:pro_gifts].enabled?(user)
  end

  def user
    current_user.resource_owner
  end
end
