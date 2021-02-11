class LibraryGapsService
  JOINS = Arel.sql(<<-JOINS.squish)
    LEFT OUTER JOIN media_attribute_votes votes
      ON votes.media_id = library_entries.media_id
      AND votes.media_type = library_entries.media_type
      AND votes.user_id = library_entries.user_id
      AND votes.vote <> 0
    LEFT OUTER JOIN media_reactions reacts
      ON reacts.library_entry_id = library_entries.id
  JOINS
  GROUP = Arel.sql(<<-GROUP.squish)
    library_entries.id
  GROUP
  PLUCK = Arel.sql(<<-PLUCK.squish)
    library_entries.id,
    COUNT(votes.id),
    library_entries.reaction_skipped,
    COUNT(reacts.id),
    COUNT(rating)
  PLUCK

  def initialize(library_entries)
    @entries = library_entries
  end

  def missing_engagement_ids
    data = @entries.completed.joins(JOINS).group(GROUP).pluck(PLUCK)

    data.each_with_object(
      attributes: [],
      reaction: [],
      rating: []
    ) do |(id, votes, reaction_skipped, reactions, ratings), out|
      out[:attributes] << id if votes.zero?
      out[:reaction] << id if reactions.zero? && reaction_skipped != 'ignored'
      out[:rating] << id if ratings.zero?
    end
  end
end
