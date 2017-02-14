class GroupResource < BaseResource
  include SluggableResource

  caching

  attributes :about, :locale, :members_count, :name, :nsfw, :privacy, :rules,
    :rules_formatted, :tags
  attributes :avatar, :cover_image, format: :attachment

  has_many :members
end
