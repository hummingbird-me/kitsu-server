module Authorization
  module Assertion
    class Facebook
      # The Aozora Facebook App ID
      AOZORA_FACEBOOK_APP_ID = '1467094533604194'.freeze
      # Facebook URL stuff
      API_VERSION = 'v2.11'.freeze
      URL_PREFIX = "https://graph.facebook.com/#{API_VERSION}".freeze
      URL_TEMPLATE = Addressable::Template.new("#{URL_PREFIX}/{+path*}{?query*}").freeze
      # The data to load from Facebook
      USER_FIELDS = {
        # User ID
        id: true,
        # Profile Info
        name: true,
        email: true,
        # If they have an Aozora account, this will let us find it
        ids_for_business: {
          id: true,
          app: %w[name]
        }
      }.freeze

      # @param access_token [String] the access token to assert login with
      def initialize(access_token)
        @access_token = access_token
      end

      # @return [User] the user to log into, given the facebook assertion
      def user!
        @user ||= if Flipper.enabled?(:aozora)
                    conflict.user!
                  else
                    User.where(facebook_id: facebook_id).first
                  end
      end

      # @return [Array<Follow>] the list of follows created based on your facebook friends list
      def auto_follows
        return unless user!

        follows = friends.map do |friend|
          friend_user = User.where(facebook_id: friend).first
          Follow.where(follower: user!, followed: friend_user).first_or_create if friend_user
        end
        follows.compact
      end

      private

      # The UserConflictDetector instance
      def conflict
        @conflict ||= Zorro::UserConflictDetector.new(facebook_id: facebook_id,
                                                      ao_facebook_id: ao_facebook_id,
                                                      email: email)
      end

      # @return [String] the Facebook ID for Kitsu
      def facebook_id
        data[:id] if data
      end

      # @return [String] the Facebook ID for Aozora
      def ao_facebook_id
        return unless data
        user = data.dig(:ids_for_business, :data).find do |obj|
          obj.dig(:app, :id) == AOZORA_FACEBOOK_APP_ID
        end
        user[:id] if user
      end

      # @return [String] the email address on their Facebook
      def email
        data.dig(:email)
      end

      # @return [Array<String>] the list of friends from this user's facebook
      def friends
        get('/me/friends', fields: { id: true })[:data].map { |friend| friend[:id] }
      end

      # @return [Hash] the raw data retrieved from the Facebook Graph API
      def data
        @data ||= get('/me', fields: USER_FIELDS)
      end

      # @return [Hash]
      def image
        @image ||= get('/me/picture', width: 180, height: 180, redirect: false)
      end

      def build_fields_param(obj)
        fields = obj.map do |key, value|
          case value
          when true then key
          when Hash then "#{key}{#{build_fields_param(value)}}"
          when Array then "#{key}{#{value.join(',')}}"
          end
        end
        fields.join(',')
      end

      # Build a URL to make a request to Facebook's Graph API
      # @param path [String] the path of the API request to make
      def build_url(path, params = {})
        path = path.sub(%r{\A/}, '')
        params = params.merge(access_token: @access_token)
        URL_TEMPLATE.expand(path: path, query: params)
      end

      # Hit the Facebook Graph API
      # @param path [String] the path of the API request to make
      # @param params [Hash] the hash of parameters
      def get(path, params = {})
        params[:fields] = build_fields_param(params[:fields]) if params[:fields]
        url = build_url(path, params)
        response = Net::HTTP.get_response(url)
        JSON.parse(response.body).deep_symbolize_keys
      end
    end
  end
end
