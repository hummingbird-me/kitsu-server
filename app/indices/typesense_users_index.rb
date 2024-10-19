# frozen_string_literal: true

class TypesenseUsersIndex < TypesenseBaseIndex
  SAVE_FREQUENCIES = {
    'id' => 1,
    'avatar_data' => 1,
    'name' => 1,
    'past_names' => 1,
    'slug' => 1,
    'followers_count' => 0.025
  }.freeze

  index_name 'users'

  schema do
    field 'avatar_image', type: 'object', optional: true, facet: false, index: false
    field 'name', type: 'string'
    field 'past_names', type: 'string[]'
    field 'slug', type: 'string', optional: true
    field 'followers_count', type: 'int32', facet: true
  end

  def self.should_sync?(changes)
    [*SAVE_FREQUENCIES.values_at(*changes.keys), 0].compact.max >= rand
  end

  def self.search_key
    ENV.fetch('TYPESENSE_USERS_SEARCH_KEY', nil)
  end

  def index(ids)
    # User.where(id: ids).find_each has far worse performance for this, probably due to the way it
    # doubles queries (once to get batch IDs, once to get the actual records). Since we have a LOT
    # of users, this optimization significantly speeds up the bulk indexing process, but isn't
    # necessary on other indices (which are much smaller).
    ids.in_groups_of(10_000, false).each do |group_ids|
      User.where(id: group_ids).each do |user|
        yield({
          id: user.id.to_s,
          avatar_image: format_image(user.avatar_attacher),
          name: user.name,
          past_names: user.past_names || [],
          slug: user.slug,
          followers_count: user.followers_count,
          created_at: user.created_at.to_i
        }.compact)
      end
    end
  end
end
