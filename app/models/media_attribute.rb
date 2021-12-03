class MediaAttribute < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: %i[slugged finders history]
  resourcify

  has_many :anime_media_attributes
  has_many :anime, through: :anime_media_attributes
  has_many :manga_media_attributes
  has_many :manga, through: :manga_media_attributes
  has_many :dramas_media_attributes
  has_many :drama, through: :dramas_media_attributes

  validates :title, presence: true
end
