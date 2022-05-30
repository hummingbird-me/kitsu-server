class GroupMember < ApplicationRecord
  belongs_to :group, optional: false, counter_cache: 'members_count', touch: true
  belongs_to :user, optional: false
  has_many :permissions, class_name: 'GroupPermission', dependent: :destroy
  has_many :notes, class_name: 'GroupMemberNote', dependent: :destroy

  counter_culture :group, column_name: ->(model) {
    model.pleb? ? nil : 'leaders_count'
  }
  update_index('users#group_member') { self }
  enum rank: { pleb: 0, mod: 1, admin: 2 }
  scope :with_permission, ->(perm) {
    joins(:permissions).merge(GroupPermission.for_permission(perm))
  }
  scope :for_user, ->(user) { where(user: user) }
  scope :in_group, ->(group) { where(group: group) }
  scope :followed_first, ->(u) { joins(:user).merge(User.followed_first(u)) }
  scope :leaders, -> { where.not(rank: 'pleb') }
  scope :blocking, ->(users) { where.not(user_id: users) }
  scope :visible_for, ->(u) { joins(:group).merge(Group.visible_for(u)) }
  scope :sfw, -> { joins(:group).merge(Group.sfw) }

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
