# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: quotes
#
#  id             :integer          not null, primary key
#  character_name :string(255)
#  content        :text             not null
#  likes_count    :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  anime_id       :integer          not null, indexed
#  character_id   :integer          not null
#  user_id        :integer          not null
#
# Indexes
#
#  index_quotes_on_anime_id  (anime_id)
#
# Foreign Keys
#
#  fk_rails_02b555fb4d  (user_id => users.id)
#  fk_rails_3a2ddd4b36  (anime_id => anime.id)
#  fk_rails_bd0c2ee7f3  (character_id => characters.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Quote, type: :model do
  subject { build(:quote) }

  it { should belong_to(:user).counter_cache(true) }
  it { should belong_to(:anime) }
  it { should belong_to(:character) }
  it { should have_many(:likes).class_name('QuoteLike') }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:anime) }
  it { should validate_presence_of(:character) }
  it { should validate_presence_of(:content) }
end
