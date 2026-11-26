# frozen_string_literal: true

class TypesenseCharactersIndex < TypesenseBaseIndex
  # The columns this index is built from; a save which touches none of them is not synced
  SYNCED_COLUMNS = %w[id names canonical_name other_names].freeze

  index_name 'characters'

  schema do
    field 'canonical_name', type: 'string'
    # ponytail: a Japanese name only matches from its start, or from the start of a part set off by
    # a space. Matching the rest (after a `・`, or the end of an unspaced name) needs infix search,
    # which did this on Typesense 30 but not 0.25; the `ja` locale matched less on both.
    field 'names', type: 'object'
    field 'names\..*', type: 'string'
    field 'other_names', type: 'string[]'
  end

  def self.should_sync?(changes)
    changes.keys.intersect?(SYNCED_COLUMNS)
  end

  def index(ids)
    Character.where(id: ids).find_each do |character|
      yield({
        id: character.id.to_s,
        canonical_name: character.canonical_name,
        names: format_localized(character.names).compact_blank,
        other_names: character.other_names.compact_blank,
        created_at: character.created_at.to_i
      }.compact)
    end
  end
end
