# == Schema Information
#
# Table name: posts
#
#  id                :integer          not null, primary key
#  blocked           :boolean          default(FALSE), not null
#  content           :text             not null
#  content_formatted :text             not null
#  deleted_at        :datetime
#  media_type        :string
#  nsfw              :boolean          default(FALSE), not null
#  spoiled_unit_type :string
#  spoiler           :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  media_id          :integer
#  spoiled_unit_id   :integer
#  target_group_id   :integer
#  target_user_id    :integer
#  user_id           :integer          not null
#
# Foreign Keys
#
#  fk_rails_5b5ddfd518  (user_id => users.id)
#  fk_rails_6fac2de613  (target_user_id => users.id)
#

class Post < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :target_user, class_name: 'User'
  belongs_to :media, polymorphic: true
  belongs_to :spoiled_unit, polymorphic: true

  validates :content, :content_formatted, presence: true
  validates :media, presence: true, if: :spoiled_unit
  validates :spoiler, acceptance: {
    accept: true,
    message: 'must be true if spoiled_unit is provided'
  }, if: :spoiled_unit

  def media_feed
    Feed.media(media_type, media_id) if media.present?
  end

  def user_feed
    Feed.user(user.id)
  end

  def target_user_feed
    Feed.user(target_user.id) if target_user.present?
  end

  after_save do
    user_feed.activities.new(
      to: [media_feed, target_user_feed].compact
    ).save
  end

  before_validation do
    self.content_formatted = content
  end
end
