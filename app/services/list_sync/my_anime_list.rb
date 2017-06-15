module ListSync
  class MyAnimeList
    attr_reader :linked_account, :agent

    def initialize(linked_account)
      @linked_account = linked_account
      @agent = Mechanize.new do |a|
        a.user_agent_alias = 'Windows Chrome'
      end
      load_session!
    end

    def logged_in?
      track_session do
        ListSync::MyAnimeList::Login.new(agent, username, password).success?
      end
    end

    def sync!(kind)
      track_session do
        xml = library_xml_for(kind)
        ListSync::MyAnimeList::XmlUploader.new(agent, xml).run!
      end
    end

    def update!(library_entry)
      track_session do
        ListSync::MyAnimeList::LibraryUpdater.new(agent, library_entry).run!
      end
    end

    def destroy!(media)
      track_session do
        ListSync::MyAnimeList::LibraryRemover.new(agent, media).run!
      end
    end

    private

    def library_xml_for(kind)
      ListSync::MyAnimeList::XmlGenerator.new(linked_account.user, kind).to_xml
    end

    def username
      linked_account.external_user_id
    end

    def password
      linked_account.token
    end

    def track_session
      yield.tap { save_session! }
    end

    def save_session!
      linked_account.update!(session_data: cookie_jar.dump)
    end

    def load_session!
      return unless linked_account.session_data.present?
      cookie_jar.load(linked_account.session_data)
    end

    def cookie_jar
      ListSync::MyAnimeList::CookieJar.new(@agent.cookie_jar)
    end
  end
end
