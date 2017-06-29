# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: drama_staff
#
#  id         :integer          not null, primary key
#  role       :string
#  created_at :datetime
#  updated_at :datetime
#  drama_id   :integer          not null, indexed, indexed => [person_id]
#  person_id  :integer          not null, indexed => [drama_id], indexed
#
# Indexes
#
#  index_drama_staff_on_drama_id                (drama_id)
#  index_drama_staff_on_drama_id_and_person_id  (drama_id,person_id) UNIQUE
#  index_drama_staff_on_person_id               (person_id)
#
# Foreign Keys
#
#  fk_rails_3b6a65697e  (person_id => people.id)
#  fk_rails_7015579db1  (drama_id => dramas.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe DramaStaff, type: :model do
  it { should belong_to(:drama) }
  it { should validate_presence_of(:drama) }
  it { should belong_to(:person) }
  it { should validate_presence_of(:person) }
  it { should validate_length_of(:role).is_at_most(140) }
end
