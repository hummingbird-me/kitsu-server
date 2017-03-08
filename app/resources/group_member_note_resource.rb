class GroupMemberNoteResource < BaseResource
  attributes :content, :content_formatted, :created_at

  has_one :group_member
  has_one :user
end
