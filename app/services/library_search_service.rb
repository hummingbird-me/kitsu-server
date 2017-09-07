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
    algolia_result_media.length
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
    @result_media_ids ||= algolia_result_media.map { |res| res.slice(:kind, :id).values }
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
      entries = filtered_library_entries.by_kind(kind).where("#{kind}_id" => ids)
      entries = entries.includes(_includes) unless _includes.blank?
      # Add them to our output hash
      out[kind] = entries.group_by(&:"#{kind}_id").transform_values(&:first)
    end
  end

  # Applies filter search for querying algolia for library entries
  #
  # @return [Hash<String, *>] from algolia response
  def algolia_result_media
    AlgoliaMediaIndex.library_search(_queries[:title].join(' '), algolia_library_entry_filter)
  end

  # Returns a string of media_type_media_id seperated by OR which will be used to query algolia
  #
  # @return String
  def algolia_library_entry_filter
    id_filters = library_media_ids.each_with_object([]) do |(type, ids), out|
      ids.each do |type_id|
        out << "#{type}_#{type_id}"
      end
    end
    "(#{id_filters.join(' OR ')})"
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
    return @entries if @entries
    # We support passing status as both a string and integer
    statuses = LibraryEntry.statuses
                           .values_at(*_filters[:status]).compact
    statuses = _filters[:status] if statuses.empty?
    _filters[:status] = statuses
    @entries = _filters.except(:kind).compact
                       .reduce(LibraryEntry) { |acc, (key, val)|
                         acc.where(key => val)
                       }
                       .limit(20_000).visible_for(@current_user)
  end
end
