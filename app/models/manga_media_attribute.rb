class MangaMediaAttribute < ApplicationRecord
  has_many :media_attribute_votes
  belongs_to :manga
  belongs_to :media_attribute
end
