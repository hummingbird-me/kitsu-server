class MangaCharacterResource < BaseResource
  attribute :role

  has_one :manga
  has_one :character
end
