# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: comments
#
#  id                :integer          not null, primary key
#  blocked           :boolean          default(FALSE), not null
#  content           :text             not null
#  content_formatted :text             not null
#  deleted_at        :datetime
#  likes_count       :integer          default(0), not null
#  replies_count     :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  parent_id         :integer
#  post_id           :integer          not null
#  user_id           :integer          not null
#
# Foreign Keys
#
#  fk_rails_31554e7034  (parent_id => comments.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :comment do
    association :user, factory: :user, strategy: :build
    association :post, factory: :post, strategy: :build
    content { Faker::Lorem.sentence }
  end
end
