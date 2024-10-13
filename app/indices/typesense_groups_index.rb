# frozen_string_literal: true

class TypesenseGroupsIndex < TypesenseBaseIndex
  SAVE_FREQUENCIES = {
    'id' => 1,
    'avatar_data' => 1,
    'name' => 1,
    'slug' => 1,
    'tagline' => 1,
    'about' => 1,
    'locale' => 1,
    'privacy' => 1,
    'is_nsfw' => 1,
    'members_count' => 0.1,
    'last_activity_at' => 0.5
  }.freeze

  index_name 'groups'

  schema do
    field 'avatar_image', type: 'object', optional: true, facet: false
    field 'name', type: 'string'
    field 'slug', type: 'string'
    field 'tagline', type: 'string', optional: true
    field 'about', type: 'string', optional: true
    field 'locale', type: 'string'
    field 'privacy', type: 'string'
    field 'is_nsfw', type: 'bool'
    field 'members_count', type: 'int32', facet: true
    # Last activity timestamp
    field 'last_activity_at', type: 'object'
    field 'last_activity_at.year', type: 'int32', facet: true, optional: true
    field 'last_activity_at.month', type: 'int32', facet: true, optional: true
    field 'last_activity_at.day', type: 'int32', facet: true, optional: true
    field 'last_activity_at.timestamp', type: 'int64', optional: true
  end

  def self.should_sync?(changes)
    [*SAVE_FREQUENCIES.values_at(*changes.keys), 0].compact.max >= rand
  end

  def self.search_key
    ENV.fetch('TYPESENSE_GROUPS_SEARCH_KEY', nil)
  end

  def index(ids)
    Group.where(id: ids).find_each do |group|
      yield({
        id: group.id.to_s,
        avatar_image: format_image(group.avatar_attacher),
        name: group.name,
        slug: group.slug,
        tagline: group.tagline,
        about: group.about,
        locale: group.locale || 'en-US',
        privacy: group.privacy,
        is_nsfw: group.nsfw?,
        members_count: group.members_count,
        last_activity_at: format_date(group.last_activity_at),
        created_at: format_date(group.created_at)
      }.compact)
    end
  end
end
