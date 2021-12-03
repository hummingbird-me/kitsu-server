class AnimeCharacter < ApplicationRecord
  enum role: %i[main supporting]

  belongs_to :anime, required: true
  belongs_to :character, required: true
  has_many :castings, class_name: 'AnimeCasting', dependent: :destroy
end
