class GroupMemberNoteResource < BaseResource
  attributes :content, :content_formatted

  has_one :group_member
  has_one :user
end
