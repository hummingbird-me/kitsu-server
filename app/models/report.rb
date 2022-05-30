# == Schema Information
#
# Table name: reports
#
#  id           :integer          not null, primary key
#  explanation  :text
#  naughty_type :string           not null, indexed => [naughty_id]
#  reason       :integer          not null
#  status       :integer          default(0), not null, indexed
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  moderator_id :integer
#  naughty_id   :integer          not null, indexed => [user_id], indexed => [naughty_type]
#  user_id      :integer          not null, indexed => [naughty_id]
#
# Indexes
#
#  index_reports_on_naughty_id_and_user_id       (naughty_id,user_id) UNIQUE
#  index_reports_on_naughty_type_and_naughty_id  (naughty_type,naughty_id)
#  index_reports_on_status                       (status)
#
# Foreign Keys
#
#  fk_rails_c7699d537d  (user_id => users.id)
#  fk_rails_cfe003e081  (moderator_id => users.id)
#
class Report < ApplicationRecord
  include WithActivity

  belongs_to :naughty, -> { with_deleted }, polymorphic: true, optional: false
  belongs_to :user, optional: false
  belongs_to :moderator, class_name: 'User', optional: true

  enum reason: { nsfw: 0, offensive: 1, spoiler: 2, bullying: 3, other: 4, spam: 5 }
  enum status: { reported: 0, resolved: 1, declined: 2 }

  validates :explanation, presence: true, if: :other?
  validates :reason, :status, presence: true

  def stream_activity
    ReportsFeed.new('global').activities.new(naughty: naughty)
  end
end
