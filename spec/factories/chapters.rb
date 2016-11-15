# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: chapters
#
#  id              :integer          not null, primary key
#  canonical_title :string           default("en_jp"), not null
#  length          :integer
#  number          :integer          not null
#  published       :date
#  synopsis        :text
#  titles          :hstore           default({}), not null
#  volume          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  manga_id        :integer          indexed
#
# Indexes
#
#  index_chapters_on_manga_id  (manga_id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :chapter do
    association :manga, factory: :manga
    titles { { en_jp: Faker::Name.name } }
    canonical_title 'en_jp'
    sequence(:number)
    length { rand(20..60) }
    volume { rand(1..10) }
    synopsis { Faker::Lorem.paragraph }
    published { Faker::Date.between(20.years.ago, Date.today) }
  end
end
