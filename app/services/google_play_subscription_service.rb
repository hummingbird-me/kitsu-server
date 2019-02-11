# frozen_string_literal: true

require 'google/apis/androidpublisher_v3'

class GooglePlaySubscriptionService
  API_KEY = ENV['GOOGLE_PLAY_API_KEY'].freeze
  PACKAGE_NAME = 'com.everfox.animetrackerandroid'

  def initialize(token, tier)
    @token = token
    @tier = tier
  end

  def cancel
    api.cancel_purchase_subscription(PACKAGE_NAME, subscription_id, @token)
  end

  def subscription_purchase
    @subscription_purchase ||= api.get_purchase_subscription(PACKAGE_NAME, subscription_id, @token)
  end
  alias_method :validate!, :subscription_purchase

  def start_date
    Time.at(subscription_purchase&.start_time_millis)
  end

  def end_date
    Time.at(subscription_purchase&.expiry_time_millis)
  end

  def api
    @api ||= Google::Apis::AndroidpublisherV3::AndroidPublisherService.new.tap do |api|
      api.key = API_KEY
    end
  end

  def subscription_id
    "io.kitsu.pro.#{@tier}-yearly"
  end
end
