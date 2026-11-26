# frozen_string_literal: true

class CharacterSearchService < TypesenseSearchService
  # Runs the search and returns the list of matching characters in order by
  # their relevance to the query.
  #
  # @return [Array<Character>] the list of matching characters
  def to_a
    # Skips any the index still holds after they left the database
    result_ids.filter_map { |id| result_characters[id.to_i] }
  end

  def query_results
    @query_results ||= query.include_fields(:id).load
  end

  private

  def result_characters
    @result_characters ||= Character.where(id: result_ids).index_by(&:id)
  end

  def result_ids
    @result_ids ||= query_results.hits.map { |res| res.document['id'] }
  end

  def query
    @query ||= begin
      query = TypesenseCharactersIndex.search(
        query: filters[:name]&.join(' ') || '',
        query_by: {
          'canonical_name' => 3,
          'names.*' => 2,
          'other_names' => 1
        }
      )
      query = apply_order_to(query) if orders
      query = apply_page_to(query)
      query = apply_per_to(query)
      query
    end
  end
end
