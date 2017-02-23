# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: marathon_events
#
#  id          :integer          not null, primary key
#  event       :integer          not null
#  status      :integer
#  unit_type   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  marathon_id :integer          not null
#  unit_id     :integer
#
# Foreign Keys
#
#  fk_rails_43eaffb81b  (marathon_id => marathons.id)
#
# rubocop:enable Metrics/LineLength

class MarathonEvent < ActiveRecord::Base
  has_paper_trail
  include WithActivity
  belongs_to :marathon, required: true

  enum event: %i[added updated consumed]
  enum status: LibraryEntry.statuses

  validates :event, presence: true
  validates :status, presence: true, if: :updated?

  delegate :library_entry, to: :marathon
  delegate :media, to: :library_entry
  delegate :user, to: :library_entry

  def stream_activity
    user.feed.activities.new(
      updated_at: updated_at,
      to: [media.feed],
      verb: event.to_s,
      status: status.to_s
    )
  end
end
