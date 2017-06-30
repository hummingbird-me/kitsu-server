# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: anime_castings
#
#  id                 :integer          not null, primary key
#  locale             :string           not null, indexed => [anime_character_id, person_id]
#  notes              :string
#  created_at         :datetime
#  updated_at         :datetime
#  anime_character_id :integer          not null, indexed, indexed => [person_id, locale]
#  licensor_id        :integer
#  person_id          :integer          not null, indexed => [anime_character_id, locale], indexed
#
# Indexes
#
#  index_anime_castings_on_anime_character_id       (anime_character_id)
#  index_anime_castings_on_character_person_locale  (anime_character_id,person_id,locale) UNIQUE
#  index_anime_castings_on_person_id                (person_id)
#
# Foreign Keys
#
#  fk_rails_5f90e1a017  (person_id => people.id)
#  fk_rails_ad010645ce  (anime_character_id => anime_characters.id)
#  fk_rails_c724c451cd  (licensor_id => producers.id)
#
# rubocop:enable Metrics/LineLength

class AnimeCasting < ApplicationRecord
  validates :locale, length: { maximum: 20 }
  validates :notes, length: { maximum: 140 }

  belongs_to :anime_character, required: true
  belongs_to :person, required: true
  belongs_to :licensor, class_name: 'Producer'
end
