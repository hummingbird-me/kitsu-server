module HTML
  class Pipeline
    class KitsuMentionFilter < MentionFilter
      # Disable "@mention" mentions
      MentionLogins = []

      # Check if user exists before we linkify it
      def link_to_mentioned_user(login)
        super if User.by_name(login).exists?
      end
    end
  end
end
