class StreamingLink < ApplicationRecord
  include Streamable

  belongs_to :media, polymorphic: true, touch: true, optional: false

  validates :media, :url, presence: true
  validates :media, polymorphism: { type: Media }
end
