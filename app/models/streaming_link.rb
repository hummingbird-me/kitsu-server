class StreamingLink < ApplicationRecord
  include Streamable

  belongs_to :media, polymorphic: true, touch: true, optional: false, inverse_of: :streaming_links

  validates :url, presence: true
  validates :media, polymorphism: { type: Media }

  after_commit do
    media.typesense_index.index_one(media.id)
  end

  def rails_admin_label
    streamer.site_name
  end
end
