class AnimeMediaAttribute < ApplicationRecord
  self.table_name = 'anime_media_attributes'
  has_many :media_attribute_votes
  belongs_to :media_attribute
  belongs_to :anime
end
