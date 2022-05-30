class DramaCharacter < ApplicationRecord
  enum role: { main: 0, supporting: 1 }

  belongs_to :drama, optional: false
  belongs_to :character, optional: false
  has_many :castings, class_name: 'DramaCasting', dependent: :destroy
end
