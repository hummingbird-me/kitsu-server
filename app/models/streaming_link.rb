class StreamingLink < ApplicationRecord
  include Streamable

  belongs_to :media, polymorphic: true, touch: true, optional: false, inverse_of: :streaming_links

  validates :media, :url, presence: true
  validates :media, polymorphism: { type: Media }

  def rails_admin_label
    streamer.site_name
  end
end
