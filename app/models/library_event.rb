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

class LibraryEvent < ApplicationRecord
  belongs_to :library_entry, required: true
  belongs_to :user, required: true
  belongs_to :anime
  belongs_to :manga
  belongs_to :drama

  enum kind: %i[progressed updated reacted rated annotated]
  validates :kind, presence: true

  scope :by_kind, ->(*kinds) do
    t = arel_table
    columns = kinds.map { |k| t[:"#{k}_id"] }
    scope = columns.shift.not_eq(nil)
    columns.each do |col|
      scope = scope.or(col.not_eq(nil))
    end
    where(scope)
  end

  def progress
    return if changed_data['progress'].nil?

    changed_data['progress'][1] - changed_data['progress'][0]
  end
end
