# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: ama_subscribers
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ama_id     :integer          not null, indexed, indexed => [user_id]
#  user_id    :integer          not null, indexed => [ama_id], indexed
#
# Indexes
#
#  index_ama_subscribers_on_ama_id              (ama_id)
#  index_ama_subscribers_on_ama_id_and_user_id  (ama_id,user_id) UNIQUE
#  index_ama_subscribers_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_3b1c2ec3ee  (user_id => users.id)
#  fk_rails_4ac07cb7f6  (ama_id => amas.id)
#
# rubocop:enable Metrics/LineLength

class AMASubscriber < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :ama, required: true, counter_cache: true

  validates :ama_id, uniqueness: { scope: :user_id }
  validates :ama, active_ama: {
    message: 'can not subscribe to this AMA',
    user: :user
  }
  after_commit on: :create do
    user.notifications.follow(ama.feed)
  end

  after_commit on: :destroy do
    user.notifications.unfollow(ama.feed)
  end
end
