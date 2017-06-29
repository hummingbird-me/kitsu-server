class LeaderChatMessageResource < BaseResource
  attributes :content, :content_formatted, :edited_at

  has_one :group
  has_one :user

  filter :group_id
end
