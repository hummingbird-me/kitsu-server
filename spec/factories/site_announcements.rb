# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: site_announcements
#
#  id          :integer          not null, primary key
#  description :text
#  image_url   :string
#  link        :string
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
# Foreign Keys
#
#  fk_rails_725ca0b80c  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :site_announcement do
    association :user, strategy: :build
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence(3) }
    image_url { Faker::LoremPixel.image }
    link { Faker::Internet.url }
  end
end
