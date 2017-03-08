# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_bans
#
#  id              :integer          not null, primary key
#  notes           :text
#  notes_formatted :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  group_id        :integer          not null, indexed
#  moderator_id    :integer          not null
#  user_id         :integer          not null, indexed
#
# Indexes
#
#  index_group_bans_on_group_id  (group_id)
#  index_group_bans_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_7dd1d13ab5  (group_id => groups.id)
#  fk_rails_816d72c5df  (user_id => users.id)
#  fk_rails_bf82b17bd6  (moderator_id => users.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :group_ban do
    association :group, strategy: :build
    association :user, strategy: :build
    association :moderator, strategy: :build, factory: :user
  end
end
