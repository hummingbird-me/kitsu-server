# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: manga_staff
#
#  id         :integer          not null, primary key
#  role       :string
#  created_at :datetime
#  updated_at :datetime
#  manga_id   :integer          not null, indexed, indexed => [person_id]
#  person_id  :integer          not null, indexed => [manga_id], indexed
#
# Indexes
#
#  index_manga_staff_on_manga_id                (manga_id)
#  index_manga_staff_on_manga_id_and_person_id  (manga_id,person_id) UNIQUE
#  index_manga_staff_on_person_id               (person_id)
#
# Foreign Keys
#
#  fk_rails_6e98078d9d  (person_id => people.id)
#  fk_rails_d9547c7576  (manga_id => manga.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe MangaStaff, type: :model do
  it { should belong_to(:manga) }
  it { should validate_presence_of(:manga) }
  it { should belong_to(:person) }
  it { should validate_presence_of(:person) }
  it { should validate_length_of(:role).is_at_most(140) }
end
