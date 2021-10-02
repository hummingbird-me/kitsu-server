class MediaCategory < ApplicationRecord
  belongs_to :media, polymorphic: true
  belongs_to :category
end
