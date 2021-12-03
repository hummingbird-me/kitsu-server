class GroupActionLog < ApplicationRecord
  belongs_to :target, required: true, polymorphic: true
  belongs_to :group, required: true
  belongs_to :user, required: true

  validates :verb, presence: true

  scope :visible_for, ->(user) {
    where(group_id: GroupMember.leaders.for_user(user).select(:group_id))
  }
end
