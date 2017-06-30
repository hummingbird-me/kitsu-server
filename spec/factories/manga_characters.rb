# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: manga_characters
#
#  id           :integer          not null, primary key
#  role         :integer          default(1), not null
#  created_at   :datetime
#  updated_at   :datetime
#  character_id :integer          not null, indexed, indexed => [manga_id]
#  manga_id     :integer          not null, indexed, indexed => [character_id]
#
# Indexes
#
#  index_manga_characters_on_character_id               (character_id)
#  index_manga_characters_on_manga_id                   (manga_id)
#  index_manga_characters_on_manga_id_and_character_id  (manga_id,character_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_6483521d5a  (character_id => characters.id)
#  fk_rails_8feeaa83b5  (manga_id => manga.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :manga_character do
    association :manga, factory: :manga, strategy: :build
    association :character, factory: :character, strategy: :build
  end
end
