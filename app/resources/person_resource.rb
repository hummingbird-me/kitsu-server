class PersonResource < BaseResource
  attributes :name, :mal_id
  attribute :image, format: :attachment

  has_many :castings
end
