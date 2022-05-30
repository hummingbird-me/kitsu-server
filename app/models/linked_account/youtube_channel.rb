class LinkedAccount
  class YoutubeChannel < LinkedAccount
    def client
      @client ||= YoutubeService::Client.new(token)
    end

    def subscription
      @subscription ||= YoutubeService::Subscription.new(self)
    end
    delegate :topic_url, to: :subscription

    before_validation do
      self.external_user_id = client.channel_id if token_changed?
    end

    validate do
      errors.add(:token, 'could not be verified') if token_changed? && !client.valid?
    end

    after_commit(on: %i[create update]) do
      if share_from_changed?
        if share_from?
          raise 'Subscribe failed' unless subscription.subscribe
        else
          raise 'Unsubscribe failed' unless subscription.unsubscribe
        end
      end
    end

    after_commit(on: :destroy) { subscription.unsubscribe }
  end
end
