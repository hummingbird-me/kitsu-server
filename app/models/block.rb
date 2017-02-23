# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  blocked_id :integer          not null, indexed
#  user_id    :integer          not null, indexed
#
# Indexes
#
#  index_blocks_on_blocked_id  (blocked_id)
#  index_blocks_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_42f8051bae  (user_id => users.id)
#  fk_rails_c7fbc30382  (blocked_id => users.id)
#
# rubocop:enable Metrics/LineLength

class Block < ApplicationRecord
  has_paper_trail
  belongs_to :user, required: true
  belongs_to :blocked, class_name: 'User', required: true

  validates :blocked, uniqueness: { scope: :user_id }

  validate :not_blocking_admin
  def not_blocking_admin
    errors.add(:blocked, "cannot be an admin") if blocked.has_role?(:admin)
    errors.add(:blocked, "cannot be a moderator") if blocked.title == 'Mod'
  end

  def self.hidden_for(user)
    return [] if user.nil?
    user = user.id if user.respond_to?(:id)
    Block.where('user_id = ? or blocked_id = ?', *[user]*2).
          pluck(:blocked_id, :user_id).flatten.uniq - [user]
  end

  after_create do
    Follow.where(follower: blocked, followed: user).destroy_all
    Follow.where(follower: user, followed: blocked).destroy_all
  end
end
