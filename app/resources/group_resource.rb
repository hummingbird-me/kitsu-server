class GroupResource < BaseResource
  caching

  attributes :about, :locale, :members_count, :name, :nsfw, :privacy, :rules,
    :rules_formatted, :slug, :tags
  attributes :avatar, :cover_image, format: :attachment
end
