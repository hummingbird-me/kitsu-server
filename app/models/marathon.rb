class Marathon < ActiveRecord::Base
  has_many :marathon_events, dependent: :destroy
  belongs_to :library_entry, required: true

  scope :current, -> { where(ended_at: nil).where.not(started_at: nil) }

  before_create do
    self.rewatch ||= library_entry.reconsuming
    true
  end
end
