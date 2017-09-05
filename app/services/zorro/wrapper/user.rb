require_dependency 'zorro/wrapper'

module Zorro
  class Wrapper
    class User < Wrapper
      def details
        @details ||= assoc(@data['_p_details'])
      end

      def name
        @data['aozoraUsername']
      end

      def email
        @data['email']
      end

      def password_digest
        @data['_hashed_password']
      end

      def followers_count
        details['followersCount']
      end

      def following_count
        details['followingCount']
      end

      def about
        details['about']
      end

      def avatar
        file(details['avatarRegular'])
      end

      def cover_image
        file(@data['banner'])
      end

      def pro?
        @data['badges']&.include?('PRO') || false
      end

      def pro_plus?
        @data['badges']&.include?('PRO+') || false
      end

      def pro_tier
        return :pro if pro?
        return :pro_plus if pro_plus?
        nil
      end

      def facebook_id
        @data.dig('_auth_data_facebook', 'id')
      end

      def admin?
        @data['badges'].include?('Admin')
      end

      # Some stuff is *always* merged
      def initial_merge_onto(user)
        password_key = user.password_digest? ? :ao_password : :password_digest
        user.assign_attributes(
          # Password Auth
          password_key => password_digest,
          # Facebook Auth
          ao_facebook_id: facebook_id,
          ao_id: id,
          ao_pro: pro_tier
        )
      end

      # Other things are only *sometimes* merged
      def full_merge_onto(user)
        user.assign_attributes(
          name: name,
          about: about,
          followers_count: followers_count,
          following_count: following_count,
          avatar: avatar,
          cover_image: cover_image,
          email: email
        )
      end
    end
  end
end
