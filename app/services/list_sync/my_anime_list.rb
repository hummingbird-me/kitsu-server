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
      ListSync::MyAnimeList::Login.new(agent, username, password).success?
    end

    def sync!(kind)
      ListSync::MyAnimeList::XmlUploader.new(agent, library_xml_for(kind)).run!
    end

    def update!(library_entry)
      ListSync::MyAnimeList::LibraryUpdater.new(agent, library_entry).run!
    end

    def destroy!(media)
      ListSync::MyAnimeList::LibraryRemover.new(agent, media).run!
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

    def save_session!
      linked_account.update(session_data: cookie_jar.dump)
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
