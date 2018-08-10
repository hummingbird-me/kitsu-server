class CleanUpQuotes < ActiveRecord::Migration
  def change
    say_with_time 'Filling character_id' do
      Quote.includes(:media).find_each do |quote|
        title = quote.media&.canonical_title&.gsub("'", '')
        next if title.nil?
        char = AlgoliaCharactersIndex.index.search(quote.character_name,
          filters: "media:'#{title}'",
          hitsPerPage: 1,
          attributesToRetrieve: ['id'],
          attributesToHighlight: []
        )['hits']&.first

        quote.update_column(:character_id, char['id']) if char
        print '.'
      end
      print "\n"
    end
  end
end
