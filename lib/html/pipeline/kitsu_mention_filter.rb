module HTML
  class Pipeline
    class KitsuMentionFilter < MentionFilter
      # Disable "@mention" mentions
      MentionLogins = [].freeze

      def call
        result[:mentioned_users] = []
        super
      end

      # Check if user exists before we linkify it
      def link_to_mentioned_user(mention)
        user = User.by_slug(mention).or(User.where(id: mention)).first
        return unless user

        result[:mentioned_users] |= [user.id]

        url = "/users/#{user.slug || user.id}"
        <<-HTML
          <a href="#{url}" class="user-mention">
            @#{user.name}
          </a>
        HTML
      end

      def username_pattern
        /[a-zA-Z0-9][a-zA-Z0-9_-]*/
      end
    end
  end
end
