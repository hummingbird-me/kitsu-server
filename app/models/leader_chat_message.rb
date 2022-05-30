class LeaderChatMessage < ApplicationRecord
  include ContentProcessable

  belongs_to :group, optional: false
  belongs_to :user, optional: false

  processable :content, InlinePipeline

  scope :visible_for, ->(user) {
    # has leadership
    where(group_id: GroupMember.leaders.for_user(user).select(:group_id))
  }

  before_save do
    self.edited_at = Time.now if content_changed?
  end
end
