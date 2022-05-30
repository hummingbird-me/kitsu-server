class GroupActionLog < ApplicationRecord
  belongs_to :target, optional: false, polymorphic: true
  belongs_to :group, optional: false
  belongs_to :user, optional: false

  validates :verb, presence: true

  scope :visible_for, ->(user) {
    where(group_id: GroupMember.leaders.for_user(user).select(:group_id))
  }
end
