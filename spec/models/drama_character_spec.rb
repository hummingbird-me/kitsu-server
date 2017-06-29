# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: drama_characters
#
#  id           :integer          not null, primary key
#  role         :integer          default(1), not null
#  created_at   :datetime
#  updated_at   :datetime
#  character_id :integer          not null, indexed, indexed => [drama_id]
#  drama_id     :integer          not null, indexed, indexed => [character_id]
#
# Indexes
#
#  index_drama_characters_on_character_id               (character_id)
#  index_drama_characters_on_drama_id                   (drama_id)
#  index_drama_characters_on_drama_id_and_character_id  (drama_id,character_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_1263ae69d4  (character_id => characters.id)
#  fk_rails_7bbf0d9933  (drama_id => dramas.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe DramaCharacter, type: :model do
  it { should belong_to(:drama) }
  it { should validate_presence_of(:drama) }
  it { should belong_to(:character) }
  it { should validate_presence_of(:character) }
  it { should define_enum_for(:role) }
end
