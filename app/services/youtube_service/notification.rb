class YoutubeService
  class Notification
    attr_reader :atom

    def initialize(atom)
      @atom = atom.is_a?(String) ? Nokogiri::XML.parse(atom) : atom
    end

    def post!(user)
      entries.map { |entry| entry.post!(user) }
    end

    def entries
      atom.xpath('//xmlns:entry').map { |entry| NotificationEntry.new(entry) }
    end
  end
end
