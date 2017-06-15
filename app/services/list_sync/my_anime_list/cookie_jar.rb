module ListSync
  class MyAnimeList
    class CookieJar
      attr_reader :jar

      def initialize(jar)
        @jar = jar
      end

      def load_from_linked_account(linked_account)
        load(linked_account.session_data) if linked_account.session_data
      end

      def save_to_linked_account(linked_account)
        linked_account.update(session_data: dump)
      end

      def load(string)
        io = StringIO.new(string)
        jar.load(io, format: :cookiestxt)
      end

      def dump
        io = StringIO.new
        jar.save(io, format: :cookiestxt)
        io.string
      end
    end
  end
end
