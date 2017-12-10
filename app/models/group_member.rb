# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_members
#
#  id           :integer          not null, primary key
#  hidden       :boolean          default(FALSE), not null
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
  # WARNING: this before_destroy ***NEEDS*** to come before the permissions
  # association, or else destruction of dependent rows occurs prior to the
  # test of whether we can destroy (based on the permissions that just got
  # destroyed!)
  # RAILS-5: Switch to `throws :abort`
  before_destroy do
    if admin?
      group.owners.count > 1
    else
      true
    end
  end

  belongs_to :group, required: true, counter_cache: 'members_count', touch: true
  belongs_to :user, required: true
  has_many :permissions, class_name: 'GroupPermission', dependent: :destroy
  has_many :notes, class_name: 'GroupMemberNote', dependent: :destroy

  counter_culture :group, column_name: ->(model) {
    model.pleb? ? nil : 'leaders_count'
  }
  update_index('users#group_member') { self }
  enum rank: %i[pleb mod admin]
  scope :with_permission, ->(perm) {
    joins(:permissions).merge(GroupPermission.for_permission(perm))
  }
  scope :for_user, ->(user) { where(user: user) }
  scope :in_group, ->(group) { where(group: group) }
  scope :followed_first, ->(u) { joins(:user).merge(User.followed_first(u)) }
  scope :leaders, -> { where.not(rank: 'pleb') }
  scope :blocking, ->(users) { where.not(user_id: users) }
  scope :visible_for, ->(u) { joins(:group).merge(Group.visible_for(u)) }
  scope :sfw, ->() { joins(:group).merge(Group.sfw) }

  def has_permission?(perm)
    permissions.for_permission(perm).exists? || permissions.for_permission(:owner).exists?
  end

  def leader?
    !pleb?
  end

  def mark_read!
    update(unread_count: 0)
  end

  def regenerate_rank!
    rank = :pleb
    rank = :mod if permissions.present?
    rank = :admin if has_permission?(:owner)
    update(rank: rank)
  end

  def public_visible
    group.public_visible?
  end

  after_commit(on: :create) do
    user.timeline.follow(group.feed) unless hidden?
  end

  after_commit(on: :update, if: :hidden_changed?) do
    if hidden?
      user.timeline.unfollow(group.feed)
    else
      user.timeline.follow(group.feed)
    end
  end

  after_commit(on: :destroy) do
    user.timeline.unfollow(group.feed)
  end
end
