# rubocop:disable Metrics/LineLength
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
# rubocop:enable Metrics/LineLength

class Report < ApplicationRecord
  has_paper_trail
  belongs_to :naughty, -> { with_deleted }, polymorphic: true, required: true
  belongs_to :user, required: true
  belongs_to :moderator, class_name: 'User', required: false

  enum reason: %i[nsfw offensive spoiler bullying other spam]
  enum status: %i[reported resolved declined]

  validates :explanation, presence: true, if: :other?
  validates :reason, :status, presence: true
end
