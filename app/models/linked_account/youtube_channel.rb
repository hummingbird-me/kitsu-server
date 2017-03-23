# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: linked_accounts
#
#  id                 :integer          not null, primary key
#  encrypted_token    :string
#  encrypted_token_iv :string
#  share_from         :boolean          default(FALSE), not null
#  share_to           :boolean          default(FALSE), not null
#  sync_to            :boolean          default(FALSE), not null
#  type               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  external_user_id   :string           not null
#  user_id            :integer          not null, indexed
#
# Indexes
#
#  index_linked_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_166e103170  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

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
      self.external_user_id = client.channel_id
    end

    validate do
      errors.add(:token, 'could not be verified') unless client.valid?
    end

    after_commit do
      if share_from_changed?
        if share_from
          raise 'Subscribe failed' unless subscription.subscribe
        else
          raise 'Unsubscribe failed' unless subscription.unsubscribe
        end
      end
    end
  end
end
