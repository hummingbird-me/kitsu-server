# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: library_events
#
#  id               :integer          not null, primary key
#  changed_data     :jsonb            not null
#  event            :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  anime_id         :integer          indexed
#  drama_id         :integer          indexed
#  library_entry_id :integer          not null
#  manga_id         :integer          indexed
#  user_id          :integer          not null, indexed
#
# Indexes
#
#  index_library_events_on_anime_id  (anime_id)
#  index_library_events_on_drama_id  (drama_id)
#  index_library_events_on_manga_id  (manga_id)
#  index_library_events_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_4f07f07655  (user_id => users.id)
#  fk_rails_8c048c3900  (library_entry_id => library_entries.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe LibraryEvent, type: :model do
  subject { described_class.new }

  it { should belong_to(:library_entry) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:library_entry) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:kind) }

  it { should define_enum_for(:kind).with(%i[progressed updated reacted rated annotated]) }
end
