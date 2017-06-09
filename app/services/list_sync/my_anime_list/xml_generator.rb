module ListSync
  class MyAnimeList
    class XmlGenerator
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
              xml << Row.new(entry).to_xml
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
        user.library_entries.by_kind(kind).includes(kind)
      end
    end
  end
end
