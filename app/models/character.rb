class Character < ApplicationRecord
  include LocalizableModel
  include Mappable
  include DescriptionSanitation
  include PortraitImageUploader::Attachment(:image)
  extend FriendlyId
  friendly_id :slug_candidates, use: %i[slugged finders history]

  validates :canonical_name, presence: true
  validates :primary_media, polymorphism: { type: Media }, allow_blank: true

  belongs_to :primary_media, polymorphic: true, optional: true
  has_many :castings
  has_many :media_characters, dependent: :destroy
  has_many :anime_characters, dependent: :destroy
  has_many :manga_characters, dependent: :destroy
  has_many :drama_characters, dependent: :destroy

  update_algolia('AlgoliaCharactersIndex')

  def canonical_name
    names[self[:canonical_name]]
  end

  def name=(value)
    names['en'] = value
    self.canonical_name = 'en'
  end

  def slug_candidates
    [
      -> { canonical_name },
      (-> { [primary_media.canonical_title, canonical_name] } if primary_media)
    ].compact
  end
end
