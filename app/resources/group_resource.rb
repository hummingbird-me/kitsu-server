class GroupResource < BaseResource
  include SluggableResource

  caching

  attributes :about, :locale, :members_count, :name, :nsfw, :privacy, :rules,
    :rules_formatted, :tags
  attributes :avatar, :cover_image, format: :attachment

  has_many :members
  has_many :neighbors

  after_create do
    # Make the current user into an owner when they create it
    member = _model.members.create!(user: actual_current_user)
    member.permissions.create!(permission: :owner)
  end
end
