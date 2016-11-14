# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: bestowment_cashes
#
#  id         :integer          not null, primary key
#  number     :integer
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  badge_id   :string
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :bestowment_cash do
    badge_id "MyString"
    rank 1
    count 1
  end
end
