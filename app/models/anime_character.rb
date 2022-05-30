class AnimeCharacter < ApplicationRecord
  enum role: { main: 0, supporting: 1 }

  belongs_to :anime, optional: false
  belongs_to :character, optional: false
  has_many :castings, class_name: 'AnimeCasting', dependent: :destroy
end
