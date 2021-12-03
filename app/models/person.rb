class Person < ApplicationRecord
  include Mappable
  include DescriptionSanitation
  include PortraitImageUploader::Attachment(:image)
  extend FriendlyId
  friendly_id :name, use: %i[slugged finders history]

  has_many :castings, dependent: :destroy
  has_many :anime_castings, dependent: :destroy
  has_many :drama_castings, dependent: :destroy
  has_many :staff, class_name: 'MediaStaff', dependent: :destroy
  has_many :voices, class_name: 'CharacterVoice', dependent: :destroy

  validates :name, presence: true
end
