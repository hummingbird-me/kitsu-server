class MyAnimeListScraper
  module SidebarKeyValueParser
    extend ActiveSupport::Concern

    def hash_for_sidebar_section(section_name)
      # For each top-level <div> tag in the section
      sidebar_sections[section_name].css('div').each_with_object({}) do |row, out|
        # Extract the key
        key = row.at_css('.dark_text').content.delete(':').strip

        # Build a NodeSet for our value
        out[key] = Nokogiri::XML::NodeSet.new(page)
        row.children.each do |node|
          out[key] << node unless node['class'] == 'dark_text'
        end
      end
    end
  end
end
