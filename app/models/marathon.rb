# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: marathons
#
#  id               :integer          not null, primary key
#  ended_at         :datetime
#  rewatch          :boolean          not null
#  started_at       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  library_entry_id :integer          not null
#
# Foreign Keys
#
#  fk_rails_786c203114  (library_entry_id => library_entries.id)
#
# rubocop:enable Metrics/LineLength

class Marathon < ActiveRecord::Base
  has_paper_trail
  has_many :marathon_events, dependent: :destroy
  belongs_to :library_entry, required: true

  scope :current, -> { where(ended_at: nil).where.not(started_at: nil) }

  before_create do
    self.rewatch ||= library_entry.reconsuming
    true
  end
end
