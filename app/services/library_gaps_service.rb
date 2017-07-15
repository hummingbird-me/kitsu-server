class LibraryGapsService
  def initialize(library_entries)
    @entries = library_entries
  end

  def missing_engagement_ids
    data = @entries.completed.joins(<<-JOINS.squish).group(<<-GROUP.squish).pluck(<<-PLUCK.squish)
      LEFT OUTER JOIN media_attribute_votes votes
        ON votes.media_id = library_entries.media_id
        AND votes.media_type = library_entries.media_type
        AND votes.user_id = library_entries.user_id
      LEFT OUTER JOIN media_reactions reacts
        ON reacts.library_entry_id = library_entries.id
    JOINS
      library_entries.id
    GROUP
      library_entries.id,
      COUNT(votes.id),
      COUNT(reacts.id),
      COUNT(rating)
    PLUCK

    data.each_with_object(
      attributes: [],
      reaction: [],
      rating: []
    ) do |(id, votes, reactions, ratings), out|
      out[:attributes] << id if votes.zero?
      out[:reaction] << id if reactions.zero?
      out[:rating] << id if ratings.zero?
    end
  end
end
