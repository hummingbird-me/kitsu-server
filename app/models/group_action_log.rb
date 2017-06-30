# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_action_logs
#
#  id          :integer          not null, primary key
#  target_type :string           not null
#  verb        :string           not null
#  created_at  :datetime         not null, indexed
#  updated_at  :datetime
#  group_id    :integer          not null, indexed
#  target_id   :integer          not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_group_action_logs_on_created_at  (created_at)
#  index_group_action_logs_on_group_id    (group_id)
#
# Foreign Keys
#
#  fk_rails_315397a42e  (group_id => groups.id)
#  fk_rails_45954c6dcd  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class GroupActionLog < ApplicationRecord
  belongs_to :target, required: true, polymorphic: true
  belongs_to :group, required: true
  belongs_to :user, required: true

  validates :verb, presence: true

  scope :visible_for, ->(user) {
    where(group_id: GroupMember.leaders.for_user(user).select(:group_id))
  }
end
