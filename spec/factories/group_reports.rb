# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_reports
#
#  id           :integer          not null, primary key
#  explanation  :text
#  naughty_type :string           not null, indexed => [naughty_id]
#  reason       :integer          not null
#  status       :integer          default(0), not null, indexed
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  group_id     :integer          not null, indexed
#  moderator_id :integer
#  naughty_id   :integer          not null, indexed => [naughty_type]
#  user_id      :integer          not null, indexed
#
# Indexes
#
#  index_group_reports_on_group_id                     (group_id)
#  index_group_reports_on_naughty_type_and_naughty_id  (naughty_type,naughty_id)
#  index_group_reports_on_status                       (status)
#  index_group_reports_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_13d07d040e  (group_id => groups.id)
#  fk_rails_32fa0c6a2d  (moderator_id => users.id)
#  fk_rails_8abfbfa356  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :group_report do
    association :group, factory: :group, strategy: :build
    association :naughty, factory: :post, strategy: :build
    association :user, factory: :user, strategy: :build
    reason :nsfw
  end
end
