class Block < ApplicationRecord
  belongs_to :user
  belongs_to :blocked, class_name: 'User'

  scope :between, ->(user_a, user_b) {
    Block.where(user_id: user_a, blocked_id: user_b)
         .or(Block.where(user_id: user_b, blocked_id: user_a))
  }

  validates :blocked, uniqueness: { scope: :user_id }

  validate :not_blocking_admin
  def not_blocking_admin
    return unless blocked
    errors.add(:blocked, 'You cannot block admins.') if blocked.permissions.admin?
    errors.add(:blocked, 'You cannot block moderators.') if blocked.permissions.community_mod?
  end

  validate :not_blocking_self
  def not_blocking_self
    return unless blocked && user
    errors.add(:blocked, 'You cannot block yourself.') if blocked == user
  end

  def self.hidden_for(user)
    return [] if user.nil?
    user = user.id if user.respond_to?(:id)
    Block.where('user_id = ? or blocked_id = ?', user, user)
         .pluck(:blocked_id, :user_id).flatten.uniq - [user]
  end

  after_create do
    Follow.where(follower: blocked, followed: user).destroy_all
    Follow.where(follower: user, followed: blocked).destroy_all
  end
end
