class MyAnimeListScraper
  module SidebarKeyValueParser
    extend ActiveSupport::Concern

    def hash_for_sidebar_section(section_name)
      # For each top-level <div> tag in the section
      sidebar_sections[section_name].css('.dark_text').each_with_object({}) do |row, out|
        # Extract the key
        key = row.content.delete(':').strip

        out[key] = Nokogiri::XML::NodeSet.new(page)
        curr = row
        loop do
          curr = curr.next
          break unless curr
          break if curr['class']&.include?('dark_text')
          break if curr.at_css('.dark_text').present?
          out[key] << curr
        end
      end
    end
  end
end
