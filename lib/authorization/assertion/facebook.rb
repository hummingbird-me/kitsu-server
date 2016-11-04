module Authorization
  module Assertion
    class Facebook
      FACEBOOK_URL = 'https://graph.facebook.com/v2.5/'.freeze
      FACEBOOK_USER_FIELDS = 'id,name,email,first_name,' \
        'last_name,gender,friends'.freeze

      def initialize(auth_code)
        @auth_code = auth_code
        @user_data = user_data
      end

      def user_data
        uri = URI.parse("#{FACEBOOK_URL}me?access_token=#{@auth_code}"\
          "&fields=#{FACEBOOK_USER_FIELDS}")
        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body)
      end

      def image
        img = URI.parse("#{FACEBOOK_URL}me/picture?"\
          "access_token=#{@auth_code}&width=180&height=180&redirect=false")
        response = Net::HTTP.get_response(img)
        JSON.parse(response.body)
      end

      def user!
        User.where(facebook_id: @user_data['id']).first if @user_data.present?
      end

      def import_friends
        return unless @user_data.present?
        user = user!
        @user_data['friends']['data'].each do |friend|
          followed = User.where(facebook_id: friend['id']).first
          Follow.find_or_create_by(
            follower: user,
            followed: followed
          ) if followed.present?
        end
      end
    end
  end
end
