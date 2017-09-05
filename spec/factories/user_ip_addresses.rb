# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: user_ip_addresses
#
#  id         :integer          not null, primary key
#  ip_address :inet             not null, indexed => [user_id]
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null, indexed => [ip_address], indexed
#
# Indexes
#
#  index_user_ip_addresses_on_ip_address_and_user_id  (ip_address,user_id) UNIQUE
#  index_user_ip_addresses_on_user_id                 (user_id)
#
# Foreign Keys
#
#  fk_rails_c13af1ff2e  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :user_ip_address do
    user
    ip_address { Faker::Internet.ip_v4_address }
  end
end
