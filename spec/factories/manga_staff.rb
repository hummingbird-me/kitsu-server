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

FactoryGirl.define do
  factory :manga_staff do
    association :manga, factory: :manga, strategy: :build
    association :person, factory: :person, strategy: :build
  end
end
