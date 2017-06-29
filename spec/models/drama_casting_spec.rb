# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: drama_castings
#
#  id                 :integer          not null, primary key
#  locale             :string           not null, indexed => [drama_character_id, person_id]
#  notes              :string
#  created_at         :datetime
#  updated_at         :datetime
#  drama_character_id :integer          not null, indexed => [person_id, locale], indexed
#  licensor_id        :integer
#  person_id          :integer          not null, indexed => [drama_character_id, locale], indexed
#
# Indexes
#
#  index_drama_castings_on_character_person_locale  (drama_character_id,person_id,locale) UNIQUE
#  index_drama_castings_on_drama_character_id       (drama_character_id)
#  index_drama_castings_on_person_id                (person_id)
#
# Foreign Keys
#
#  fk_rails_13a6ca2d95  (person_id => people.id)
#  fk_rails_25f32514ae  (drama_character_id => drama_characters.id)
#  fk_rails_aef2c89cbe  (licensor_id => producers.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe DramaCasting, type: :model do
  it { should belong_to(:drama_character) }
  it { should validate_presence_of(:drama_character) }
  it { should belong_to(:person) }
  it { should validate_presence_of(:person) }
  it { should belong_to(:licensor).class_name('Producer') }
  it { should validate_length_of(:locale).is_at_most(20) }
  it { should validate_length_of(:notes).is_at_most(140) }
end
