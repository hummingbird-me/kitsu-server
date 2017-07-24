# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_members
#
#  id           :integer          not null, primary key
#  hidden       :boolean          default(FALSE), not null
#  rank         :integer          default(0), not null, indexed
#  unread_count :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#  group_id     :integer          not null, indexed, indexed => [user_id]
#  user_id      :integer          not null, indexed, indexed => [group_id]
#
# Indexes
#
#  index_group_members_on_group_id              (group_id)
#  index_group_members_on_rank                  (rank)
#  index_group_members_on_user_id               (user_id)
#  index_group_members_on_user_id_and_group_id  (user_id,group_id) UNIQUE
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :group_member do
    group
    user
  end
end
