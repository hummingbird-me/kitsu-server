class Quote < ApplicationRecord
  include WithActivity

  belongs_to :user, counter_cache: true
  belongs_to :media, polymorphic: true, inverse_of: :quotes
  has_many :likes, class_name: 'QuoteLike', dependent: :destroy
  has_many :lines, -> { rank(:order) },
    class_name: 'QuoteLine',
    dependent: :destroy,
    inverse_of: :quote
  accepts_nested_attributes_for :lines, allow_destroy: true

  def stream_activity
    media.feed.activities.new(media: media)
  end
end
