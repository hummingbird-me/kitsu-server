module Authorization
  module Assertion
    class Apple
      
      def initialize(jwt)
        @jwt = jwt
      end

      def user!
        @user ||= User.where(apple_id: apple_id).first
      end

      private

      def data
        @data ||= AppleAuth::ServerIdentity.new(@jwt).validate!
      end

      def email
        data[:email]
      end

      def apple_id
        data[:sub] if data
      end
    end
  end
end
