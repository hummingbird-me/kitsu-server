class AnimeCharacterResource < BaseResource
  attribute :role

  has_one :anime
  has_one :character
  has_many :castings
end
