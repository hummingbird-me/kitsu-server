# frozen_string_literal: true

module Authorization
  module Assertion
    class Apple
      APPLE_KEYS = 'https://appleid.apple.com/auth/keys'

      def initialize(jwt, user_id)
        @jwt = jwt
        @user_id = user_id
      end

      def user!
        return nil unless validate!
        @user ||= User.where(apple_id:).first
      end

      private

      def data
        @data ||= decode_jwt
      end

      def apple_id
        data[:sub]
      end

      def email
        data[:email]
      end

      def validate!
        validate_aud && validate_exp && validate_sub && validate_iat && validate_iss
      end

      def validate_sub
        apple_id == @user_id
      end

      def validate_iat
        data[:iat].to_i <= Time.now.to_i
      end

      def validate_exp
        data[:exp].to_i > Time.now.to_i
      end

      def validate_aud
        data[:aud] == ENV['APPLE_CLIENT_ID']
      end

      def validate_iss
        data[:iss] == 'https://appleid.apple.com'
      end

      def decode_jwt
        return {} unless @jwt
        jwt_header = JSON.parse(Base64.decode64(@jwt.split('.').first))

        response = Net::HTTP.get(URI.parse(APPLE_KEYS))
        apple_jwks = JSON.parse(response)
        matching_key = apple_jwks['keys'].select { |key| key['kid'] == jwt_header['kid'] }

        jwk = JWT::JWK.create_from(matching_key.first)
        @decoded_jwt = JWT.decode(@jwt, jwk.public_key, true, algorithm: matching_key.first['alg'])
        @decoded_jwt.first.deep_symbolize_keys
      end
    end
  end
end
