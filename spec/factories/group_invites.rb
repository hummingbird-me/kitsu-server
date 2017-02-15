# == Schema Information
#
# Table name: group_invites
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer          not null, indexed
#  sender_id  :integer          not null, indexed
#  user_id    :integer          not null, indexed
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

FactoryGirl.define do
  factory :group_invite do
    group
    user
    association :sender, factory: :user
  end
end
