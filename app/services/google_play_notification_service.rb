# Handles processing the event we receive from GCP Pub/Sub, determining if it's a test notification
# or a proper subscription notification, then processing the subscription notifications by their
# event type.
class GooglePlayNotificationService
  EVENTS = {
    1 => :recovered,
    2 => :renewed,
    3 => :canceled,
    4 => :purchased,
    5 => :on_hold,
    6 => :in_grace_period,
    7 => :restarted,
    8 => :price_change_confirmed,
    9 => :deferred
  }.freeze

  def initialize(notif)
    @notif = notif
  end

  def data
    @data ||= Oj.load(Base64.decode64(@notif.dig('message', 'data')))
  end

  def event
    @event ||= EVENTS[data.dig('subscriptionNotification', 'notificationType')]
  end

  def token
    @token ||= data.dig('subscriptionNotification', 'purchaseToken')
  end

  def subscription
    ProSubscription::GooglePlaySubscription.find_by(billing_id: token)
  end

  def call
    return unless data['subscriptionNotification']

    case event
    when :renewed, :purchased
      GooglePlayRenewalService.new(@oken).call
    when :canceled
      subscription&.destroy!
    end
  end
end
