class Quote < ApplicationRecord
  include WithActivity

  # defaults to required: true in Rails 5
  belongs_to :user, optional: false, counter_cache: true
  belongs_to :media, optional: false, polymorphic: true
  has_many :likes, class_name: 'QuoteLike', dependent: :destroy
  has_many :lines, -> { rank(:order) }, class_name: 'QuoteLine', dependent: :destroy

  def stream_activity
    media.feed.activities.new(media: media)
  end
end
