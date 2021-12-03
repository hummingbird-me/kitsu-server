class LeaderChatMessage < ApplicationRecord
  include ContentProcessable

  belongs_to :group, required: true
  belongs_to :user, required: true

  processable :content, InlinePipeline

  scope :visible_for, ->(user) {
    # has leadership
    where(group_id: GroupMember.leaders.for_user(user).select(:group_id))
  }

  before_save do
    self.edited_at = Time.now if content_changed?
  end
end
