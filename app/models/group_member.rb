# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_members
#
#  id           :integer          not null, primary key
#  rank         :integer          default(0), not null, indexed
#  unread_count :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#  group_id     :integer          not null, indexed, indexed => [user_id]
#  user_id      :integer          not null, indexed, indexed => [group_id]
#
# Indexes
#
#  index_group_members_on_group_id              (group_id)
#  index_group_members_on_rank                  (rank)
#  index_group_members_on_user_id               (user_id)
#  index_group_members_on_user_id_and_group_id  (user_id,group_id) UNIQUE
#
# rubocop:enable Metrics/LineLength

class GroupMember < ApplicationRecord
  belongs_to :group, required: true, counter_cache: 'members_count'
  belongs_to :user, required: true
  has_many :permissions, class_name: 'GroupPermission', dependent: :destroy

  counter_culture :group, column_name: ->(model) {
    model.pleb? ? nil : 'leaders_count'
  }
  enum rank: %i[pleb mod admin]
  scope :with_permission, ->(perm) {
    joins(:permissions).merge(GroupPermission.for_permission(perm))
  }
  scope :for_user, ->(user) { where(user: user) }
  scope :in_group, ->(group) { where(group: group) }
  scope :followed_first, ->(u) { joins(:user).merge(User.followed_first(u)) }
  scope :leaders, -> { where.not(rank: 'pleb') }

  validate(on: :destroy) do
    if admin? && group.owners.count == 1
      errors.add(:group, 'must always have at least one owner')
    end
  end

  def has_permission?(perm)
    permissions.for_permission(perm).exists?
  end

  def leader?
    !model.pleb?
  end

  def regenerate_rank!
    rank = :pleb
    rank = :mod if permissions.present?
    rank = :admin if has_permission?(:owner)
    update(rank: rank)
  end
end
