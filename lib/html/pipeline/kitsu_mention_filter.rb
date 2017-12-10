module HTML
  class Pipeline
    class KitsuMentionFilter < MentionFilter
      # Disable "@mention" mentions
      MentionLogins = [].freeze

      def base_url
        '/users/'
      end

      # Check if user exists before we linkify it
      def link_to_mentioned_user(login)
        super if User.by_slug(login).exists?
      end

      def username_pattern
        /[a-zA-Z0-9][a-zA-Z0-9_]*/
      end
    end
  end
end
