# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: leader_chat_messages
#
#  id                :integer          not null, primary key
#  content           :text             not null
#  content_formatted :text             not null
#  edited_at         :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  group_id          :integer          not null, indexed
#  user_id           :integer          not null, indexed
#
# Indexes
#
#  index_leader_chat_messages_on_group_id  (group_id)
#  index_leader_chat_messages_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_638f2b72ee  (group_id => groups.id)
#  fk_rails_bbfcd4b318  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

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
