module Authorization
  module Assertion
    class Twitter
      def initialize(access_token, access_token_secret)
        @access_token = access_token
        @access_token_secret = access_token_secret
        @twitter_client ||= ::Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
          config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
          config.access_token        = @access_token
          config.access_token_secret = @access_token_secret
        end
      end

      def user_data
        @twitter_client.user
      end

      def image
        img = URI.parse(user_data.profile_image_url)
        Net::HTTP.get_response(img)
      end

      def user!
        User.where(twitter_id: user_data.id).first if user_data.present?
      end

      def import_friends
        return unless user_data.present?
        followers = @twitter_client.friends
        followers.each do |friend|
          followed = User.where(twitter_id: friend.id).first
          Follow.find_or_create_by(
            follower: user!,
            followed: followed
          ) if followed.present?
        end
      end
    end
  end
end
