class MediaCategory < ApplicationRecord
  belongs_to :media, polymorphic: true
  belongs_to :category

  after_commit do
    media.typesense_index.index_one(media.id)
  end
end
