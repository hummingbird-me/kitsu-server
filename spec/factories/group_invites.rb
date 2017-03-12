# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_invites
#
#  id          :integer          not null, primary key
#  accepted_at :datetime
#  declined_at :datetime
#  revoked_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  group_id    :integer          not null, indexed
#  sender_id   :integer          not null, indexed
#  user_id     :integer          not null, indexed
#
# Indexes
#
#  index_group_invites_on_group_id   (group_id)
#  index_group_invites_on_sender_id  (sender_id)
#  index_group_invites_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_62774fb6d2  (sender_id => users.id)
#  fk_rails_7255dc4343  (group_id => groups.id)
#  fk_rails_d969f0761c  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :group_invite do
    before(:create) do |_invite, evaluator|
      Follow.create!(follower: evaluator.user, followed: evaluator.sender)
    end
    group
    user
    association :sender, factory: :user
  end
end
