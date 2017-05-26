# Encapsulates the task of searching library entries, taking a query and a user,
# and handing us the result set as an Array.  Normally, we wouldn't need this
# much complexity just to search a model, but library entries are a special
# case: we have millions of them, and indexing them directly is grossly
# inefficient.  Instead, we go through the MediaIndex and filter in the IDs in
# the user's library, then find the library entries for the result set.
class LibrarySearchService < SearchService
  # Runs the search and returns the list of matching library entries in order by
  # their relevance to the queries.
  #
  # @return [Array<LibraryEntry>] the list of matching library entries
  def to_a
    result_media_ids.map do |(kind, id)|
      result_entries[kind][id.to_i]
    end
  end

  # Returns the total number of library entries which match the filter and query
  #
  # @return [Integer] the total number of results
  def total_count
    result_media.total_count
  end

  # Sets the current user for the search, so we can handle hiding library
  # entries which would be invisible to them (via privacy or NSFW)
  def visible_for(user)
    @current_user = user
    self
  end

  private

  # Extracts the Media IDs listed in the results set and returns a list of their
  # type and id
  #
  # @return [Array<Array<String, String>>] an array of [type, id] pairs
  def result_media_ids
    @result_media_ids ||= result_media.only(:_id, :_type).to_a.map do |res|
      res._data.slice('_type', '_id').values
    end
  end

  # Loads the library entries and returns a nested hash keyed on type and id
  #
  # @return [Hash<String, Hash<Integer, LibraryEntry>>] the media
  def result_entries
    return @result_entries if @result_entries
    # Zip them up by type
    load_ids = result_media_ids.each_with_object({}) do |(kind, id), out|
      out[kind] ||= []
      out[kind] << id.to_i
    end
    # For each type
    @result_entries = load_ids.each_with_object({}) do |(kind, ids), out|
      # Load the entries
      entries = LibraryEntry.by_kind(kind).where("#{kind}_id" => ids)
      entries = entries.includes(_includes) unless _includes.blank?
      # Add them to our output hash
      out[kind] = entries.group_by(&:"#{kind}_id").map { |id, entries|
        { id => entries.first }
      }.reduce(&:merge)
    end
  end

  # Apply the library entry filter, the media query, and apply includes and
  # orders
  #
  # @return [MediaIndex] the index filtered
  def result_media
    # Filter by LibraryEntry Media IDs
    query = MediaIndex.filter(library_entry_filter)
    # Pagination
    query = apply_offset_to(query)
    query = apply_limit_to(query)
    # Order
    query = apply_order_to(query)
    # Apply media query
    query = query.query(media_query)
    query
  end

  # Generates a query that matches the media by their information.
  #
  # @todo move this into a MediaSearchService
  #
  # @return [Hash] the ElasticSearch query object
  def media_query
    {
      bool: {
        should: [
          { multi_match: {
            fields: %w[titles.* abbreviated_titles],
            query: _queries[:title].join(' '),
            fuzziness: 'AUTO',
            max_expansions: 15,
            prefix_length: 2
          } },
          { multi_match: {
            fields: %w[titles.* abbreviated_titles],
            type: 'phrase_prefix',
            query: _queries[:title].join(' '),
            boost: 1.2
          } }
        ]
      }
    }
  end

  # Generates a `bool` query that `should` match all media in the filtered
  # library entries.  Should be applied as a `filter` on the Chewy scope
  #
  # @return [Hash] the ElasticSearch query object
  def library_entry_filter
    id_filters = library_media_ids.map do |type, ids|
      { ids: { type: type, values: ids } }
    end
    { bool: { should: id_filters } }
  end

  # Returns the IDs of all media that match the filters provided
  #
  # @return [Hash<String, Array<Integer>>] media ids by type
  def library_media_ids
    media_types = %w[anime manga drama]
    # Only request the types that we are filtering on
    if _filters.key? :kind
      kinds = media_types & _filters[:kind].first.split(',')
      media_types = kinds unless kinds.empty?
    end
    media_types.map do |kind|
      [kind, filtered_library_entries.by_kind(kind).pluck("#{kind}_id")]
    end
  end

  # Applies the filters for the LibraryEntry and returns the resulting scope.
  # Also applies a limit of 20,000 to prevent retrieving all library entries in
  # existence.
  #
  # @return [ActiveRecord::Relation<LibraryEntry>] the resulting scope
  def filtered_library_entries
    # Kind doesn't exist on the library_entries table.
    if _filters.key? :kind
      _filters[:media_type] = _filters[:kind]&.first.split(',')
                                                    .map(&:capitalize)
    end
    # We support passing status as both a string and integer
    statuses = LibraryEntry.statuses
                           .values_at(*_filters[:status]).compact
    statuses = _filters[:status] if statuses.empty?
    _filters[:status] = statuses
    @entries ||= _filters.except(:kind).compact
                         .reduce(LibraryEntry) { |acc, (key, val)|
                           acc.where(key => val)
                         }
                         .limit(20_000).visible_for(@current_user)
  end
end
