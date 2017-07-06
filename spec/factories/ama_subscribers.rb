# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: ama_subscribers
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ama_id     :integer          not null, indexed, indexed => [user_id]
#  user_id    :integer          not null, indexed => [ama_id], indexed
#
# Indexes
#
#  index_ama_subscribers_on_ama_id              (ama_id)
#  index_ama_subscribers_on_ama_id_and_user_id  (ama_id,user_id) UNIQUE
#  index_ama_subscribers_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_3b1c2ec3ee  (user_id => users.id)
#  fk_rails_4ac07cb7f6  (ama_id => amas.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :ama_subscriber do
    ama
    user
  end
end
