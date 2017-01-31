class DramaCharacterResource < BaseResource
  attribute :role

  has_one :drama
  has_one :character
  has_many :castings
end
