class ProGiftsController < ApplicationController
  include CustomControllerHelpers

  before_action :check_feature_flag!
  before_action :authenticate_user!

  def create
    gift.validate!

    case params[:service].downcase
    when 'stripe'
      StripeGiftService.new(from: user, to: to, token: params[:token], length: params[:length]).call
    else
      return render_jsonapi_error 400, 'Unknown payment service'
    end

    gift.send

    render status: 200, json: gift
  rescue ProGiftService::InvalidSelfGift
    render_jsonapi_error 400, 'Cannot gift to self'
  rescue ProGiftService::RecipientIsPro
    render_jsonapi_error 400, 'Cannot gift to a user who already has pro'
  rescue ActiveRecord::RecordNotFound
    render_jsonapi_error 404, 'Recipient not found'
  end

  private

  def gift
    @gift ||= ProGiftService.new(from: user, to: to, message: message, length: params[:length])
  end

  def to
    @to ||= User.find(params[:to])
  end

  def message
    @message ||= params[:message].presence
  end

  def length
    @length ||= params[:length].to_sym
  end

  def check_feature_flag!
    render status: 404 unless Flipper[:pro_gifts].enabled?(user)
  end

  def user
    current_user.resource_owner
  end
end
