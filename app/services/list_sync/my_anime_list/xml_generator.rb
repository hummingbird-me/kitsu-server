module ListSync
  class MyAnimeList
    class XMLGenerator
      attr_reader :user, :kind

      def initialize(user, kind)
        @user = user
        @kind = kind
      end

      def to_xml
        Nokogiri::XML::Builder.new { |xml|
          xml.myanimelist do
            xml.myinfo do
              xml.user_export_type export_type
            end

            library_entries.each do |entry|
              xml << Row.new(entry, mappings[entry.media_id]).to_xml
            end
          end
        }.to_xml
      end

      private

      def export_type
        case kind
        when :anime then 1
        when :manga then 2
        end
      end

      def library_entries
        @library_entries ||= user.library_entries.by_kind(kind).includes(kind)
      end

      def mappings
        @mappings ||= Mapping.where(
          item_type: kind.to_s.classify,
          item_id: user.library_entries.select(:media_id),
          external_site: "myanimelist/#{kind}"
        ).pluck(:item_id, :external_id).to_h
      end
    end
  end
end
