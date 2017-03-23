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
  class YouTubeChannel < LinkedAccount
    API_PREFIX = 'https://www.googleapis.com/youtube/v3'.freeze
    CHANNEL_URL = Addressable::Template.new(
      "#{API_PREFIX}/channels.list?part=id&mine=true{&query*}"
    ).freeze
    VERIFY_URL = Addressable::Template.new(
      "#{API_PREFIX}/tokeninfo{?query*}"
    ).freeze

    def subscription
      @subscription ||= YouTubeSubscription.new(self, external_user_id)
    end

    validate do
      res = Typhoeus.get(VERIFY_URL.expand(query: { access_token: token }))
      unless res.success? && res.aud == ENV['YOUTUBE_API_KEY']
        errors.add(:token, 'could not be verified')
      end
    end

    before_validation do
      # Get the Channel ID with the token and save it
      res = Typhoeus.get(CHANNEL_URL.expand(query: { access_token: token }))
      data = JSON.parse(res.body)
      self.external_user_id = data.id if res.success?
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
