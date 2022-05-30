class AMASubscriber < ApplicationRecord
  belongs_to :user, optional: false
  belongs_to :ama, optional: false, counter_cache: true

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
