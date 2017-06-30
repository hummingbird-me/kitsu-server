# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: anime_characters
#
#  id           :integer          not null, primary key
#  role         :integer          default(1), not null
#  created_at   :datetime
#  updated_at   :datetime
#  anime_id     :integer          not null, indexed, indexed => [character_id]
#  character_id :integer          not null, indexed => [anime_id], indexed
#
# Indexes
#
#  index_anime_characters_on_anime_id                   (anime_id)
#  index_anime_characters_on_anime_id_and_character_id  (anime_id,character_id) UNIQUE
#  index_anime_characters_on_character_id               (character_id)
#
# Foreign Keys
#
#  fk_rails_2f1dc82248  (character_id => characters.id)
#  fk_rails_6a2ab0f6ab  (anime_id => anime.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe AnimeCharacter, type: :model do
  it { should belong_to(:anime) }
  it { should validate_presence_of(:anime) }
  it { should belong_to(:character) }
  it { should validate_presence_of(:character) }
  it { should define_enum_for(:role) }
end
