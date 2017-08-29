require_dependency 'zorro/wrapper'

module Zorro
  class Wrapper
    class User < Wrapper
      def name
        @data['aozoraUsername']
      end

      def email
        @data['email']
      end

      def password_digest
        @data['_hashed_password']
      end

      def merge_onto(user)
        user.assign_attributes(
          name: name,
          aozora_id: id,
          email: email,
          password_digest: password_digest
        )
      end
    end
  end
end
