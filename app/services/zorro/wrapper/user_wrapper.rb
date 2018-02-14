module Zorro
  class Wrapper
    class UserWrapper < Wrapper
      # @return [Hash] the associated details document
      def details
        @details ||= @data['details'].presence || assoc(@data['_p_details']) || {}
      end

      # Aozora wasn't always strictly checking these, so about 15,000 users have non-ASCII chars in
      # their names.
      # @return [String] the username
      def name
        @data['aozoraUsername'][0..20]
      end

      # About 43,000 Aozora users are missing this
      # @return [String,nil] the email address
      def email
        @data['email']
      end

      # About 87,000 Aozora users are missing this
      # @return [String,nil] the password hash
      def password_digest
        @data['_hashed_password']
      end

      # @return [Number] the number of users following this one
      def followers_count
        details['followersCount'] || 0
      end

      # @return [Number] the number of users this user follows
      def following_count
        details['followingCount'] || 0
      end

      # @return [String] the user's about text
      def about
        if details['about']
          # This insane regex removes all unicode control characters except for \n
          details['about'][0..499].gsub(/[\p{Cc}&&[^\n]]/u, '')
        else
          ''
        end
      end

      # @return [String] the URL to the user's avatar
      def avatar
        file(details['avatarRegular'])
      end

      # @return [String] the URL to the user's banner image
      def cover_image
        file(@data['banner'])
      end

      # @return [Boolean] whether the user has bought Aozora PRO
      def pro?
        @data['badges']&.include?('PRO') || false
      end

      # @return [Boolean] whether the user has bought Aozora PRO+
      def pro_plus?
        @data['badges']&.include?('PRO+') || false
      end

      # @return [:pro,:pro_plus,nil] the tier of Aozora PRO that this user has
      def pro_tier
        return :pro if pro?
        return :pro_plus if pro_plus?
        nil
      end

      # NOTE: Facebook issues separate IDs to each application, so these can't be matched directly
      # against Kitsu Facebook IDs, and need to be matched using the ids_for_business edge in the
      # FB Graph API.
      #
      # @return [String,nil] the Aozora Facebook ID
      def facebook_id
        @data.dig('_auth_data_facebook', 'id')
      end

      # About 317,000 users have no badges whatsoever
      # @return [Boolean] whether the user is an Aozora admin or not
      def admin?
        @data['badges']&.include?('Admin')
      end

      def status
        if password_digest.blank? || email.blank?
          :incomplete
        else
          :registered
        end
      end

      # Merge authentication data and Aozora-specific attributes onto a user model. These attributes
      # can be merged without asking the user first, since they're nondestructive.
      #
      # @param user [User] the user to assign attributes onto
      # @return [void]
      def initial_merge_onto(user)
        password_key = user.password_digest? ? :ao_password : :password_digest
        user.assign_attributes(
          # Password Auth
          password_key => password_digest,
          # Facebook Auth
          ao_facebook_id: facebook_id,
          ao_id: id,
          ao_pro: pro_tier,
          followers_count: user.followers_count + followers_count,
          following_count: user.following_count + following_count,
          status: :aozora
        )
      end

      # Merge all data onto a user model.  This is a destructive operation, so we need to ask the
      # user first.
      #
      # @param user [User] the user to assign attributes onto
      # @return [void]
      def full_merge_onto(user)
        user.assign_attributes(
          name: name,
          about: about,
          avatar: avatar,
          cover_image: cover_image,
          email: email,
          # This column marks this account as imported from Aozora, so we can ignore it when it
          # conflicts with the original Aozora user
          ao_imported: id
        )
      end
    end
  end
end
