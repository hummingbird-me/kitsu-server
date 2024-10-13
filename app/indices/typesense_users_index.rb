# frozen_string_literal: true

class TypesenseUsersIndex < TypesenseBaseIndex
  SAVE_FREQUENCIES = {
    'name' => 1,
    'past_names' => 1,
    'slug' => 1,
    'followers_count' => 0.025
  }.freeze

  index_name 'users'

  schema do
    field 'avatar_image', type: 'object', optional: true, facet: false
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
    User.where(id: ids).find_each do |user|
      yield({
        id: user.id.to_s,
        name: user.name,
        past_names: user.past_names,
        slug: user.slug,
        followers_count: user.followers_count
      }.compact)
    end
  end
end
