class AlgoliaCharactersIndex < BaseIndex
  self.index_name = 'characters'

  # Names & Bio
  attributes :names, :canonical_name, :other_names, :description

  # Display Only
  attribute :slug
  attribute :image, format: ShrineAttachmentValueFormatter

  has_many :media, via: 'media_characters.media', as: :canonical_title, polymorphic: true
  has_one :primary_media, via: 'primary_media', as: :canonical_title, polymorphic: true
end
