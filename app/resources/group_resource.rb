class GroupResource < BaseResource
  include SluggableResource

  caching

  attributes :about, :locale, :members_count, :name, :nsfw, :privacy, :rules,
    :rules_formatted, :tags, :leaders_count, :neighbors_count, :featured
  attributes :avatar, :cover_image, format: :attachment

  filter :featured, verify: ->(values, _) {
    # If the values seem falsy, treat them as false.  Otherwise probably true.
    !(/false|f|0|no/ =~ values.join.downcase)
  }

  has_many :members
  has_many :neighbors
  has_many :tickets
  has_many :invites
  has_many :reports
  has_many :leader_chat_messages
  has_many :action_logs

  after_create do
    # Make the current user into an owner when they create it
    member = _model.members.create!(user: actual_current_user)
    member.permissions.create!(permission: :owner)
  end
end
