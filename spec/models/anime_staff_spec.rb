# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: anime_staff
#
#  id         :integer          not null, primary key
#  role       :string
#  created_at :datetime
#  updated_at :datetime
#  anime_id   :integer          not null, indexed, indexed => [person_id]
#  person_id  :integer          not null, indexed => [anime_id], indexed
#
# Indexes
#
#  index_anime_staff_on_anime_id                (anime_id)
#  index_anime_staff_on_anime_id_and_person_id  (anime_id,person_id) UNIQUE
#  index_anime_staff_on_person_id               (person_id)
#
# Foreign Keys
#
#  fk_rails_cdd9599b2a  (person_id => people.id)
#  fk_rails_f8b16cdc79  (anime_id => anime.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe AnimeStaff, type: :model do
  it { should belong_to(:anime) }
  it { should validate_presence_of(:anime) }
  it { should belong_to(:person) }
  it { should validate_presence_of(:person) }
  it { should validate_length_of(:role).is_at_most(140) }
end
