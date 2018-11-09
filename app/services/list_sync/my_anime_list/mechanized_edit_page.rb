module ListSync
  class MyAnimeList
    module MechanizedEditPage
      extend ActiveSupport::Concern

      included do
        attr_reader :agent, :media
      end

      def initialize(agent, media)
        @agent = agent
        @media = media
      end

      private

      def check_authentication!
        raise ListSync::AuthenticationError if edit_page.uri.to_s.include?('login.php')
      end

      def edit_page
        return @edit_page if @edit_page
        raise ListSync::NotFoundError unless mal_id

        url = "https://myanimelist.net/ownlist/#{media_kind}/#{mal_id}/edit"
        @edit_page = @agent.get(url)
      rescue Mechanize::UnauthorizedError
        raise ListSync::AuthenticationError
      rescue Mechanize::ResponseCodeError
        raise ListSync::RemoteError
      end

      def csrf_token
        edit_page.search('meta[name="csrf_token"]').first['content']
      end

      # MyAnimeList copies the CSRF token into the form using JavaScript, but
      # Mechanize can't run JS, so we manually copy it into the form before
      # submission.
      def copy_csrf_token_into(form)
        form['csrf_token'] = csrf_token
      end

      def mal_mapping
        @mal_mapping ||= media.mapping_for("myanimelist/#{media_kind}")
      end

      def mal_id
        mal_mapping&.external_id
      end

      def media_kind
        media.class.name.underscore
      end
    end
  end
end
