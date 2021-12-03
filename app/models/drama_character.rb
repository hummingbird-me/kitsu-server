class DramaCharacter < ApplicationRecord
  enum role: %i[main supporting]

  belongs_to :drama, required: true
  belongs_to :character, required: true
  has_many :castings, class_name: 'DramaCasting', dependent: :destroy
end
