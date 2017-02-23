# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: media_follows
#
#  id         :integer          not null, primary key
#  media_type :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  media_id   :integer          not null
#  user_id    :integer          not null
#
# Foreign Keys
#
#  fk_rails_4407210d20  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class MediaFollow < ActiveRecord::Base
  has_paper_trail
  belongs_to :user, required: true, touch: true
  belongs_to :media, required: true, polymorphic: true

  validates :media, polymorphism: { type: Media }

  after_create do
    user.timeline.follow(media.feed)
  end

  after_destroy do
    user.timeline.unfollow(media.feed)
  end
end
