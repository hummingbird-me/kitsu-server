# == Schema Information
#
# Table name: posts
#
#  id                :integer          not null, primary key
#  blocked           :boolean          default(FALSE), not null
#  comments_count    :integer          default(0), not null
#  content           :text             not null
#  content_formatted :text             not null
#  deleted_at        :datetime
#  media_type        :string
#  nsfw              :boolean          default(FALSE), not null
#  post_likes_count  :integer          default(0), not null
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
#  fk_rails_43023491e6  (target_user_id => users.id)
#  fk_rails_5b5ddfd518  (user_id => users.id)
#

class Post < ApplicationRecord
  include WithActivity

  belongs_to :user, required: true
  belongs_to :target_user, class_name: 'User'
  belongs_to :media, polymorphic: true
  belongs_to :spoiled_unit, polymorphic: true
  has_many :post_likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :content, :content_formatted, presence: true
  validates :media, presence: true, if: :spoiled_unit
  validates :spoiler, acceptance: {
    accept: true,
    message: 'must be true if spoiled_unit is provided'
  }, if: :spoiled_unit

  def stream_activity
    user.feed.activities.new(
      updated_at: updated_at,
      post_likes_count: post_likes_count,
      comments_count: comments_count,
      to: [media&.feed, target_user&.feed, target_user&.notifications].compact
    )
  end

  before_validation do
    if content_changed?
      self.content_formatted = InlinePipeline.call(content)[:output].to_s
    end
  end
end
