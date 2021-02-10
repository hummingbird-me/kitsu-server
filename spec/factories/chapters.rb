# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: chapters
#
#  id                     :integer          not null, primary key
#  canonical_title        :string           default("en_jp"), not null
#  length                 :integer
#  number                 :integer          not null
#  published              :date
#  synopsis               :text
#  thumbnail_content_type :string(255)
#  thumbnail_file_name    :string(255)
#  thumbnail_file_size    :integer
#  thumbnail_meta         :text
#  thumbnail_updated_at   :datetime
#  titles                 :hstore           default({}), not null
#  volume_number          :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  manga_id               :integer          indexed
#
# Indexes
#
#  index_chapters_on_manga_id   (manga_id)
#
# rubocop:enable Metrics/LineLength

FactoryBot.define do
  factory :chapter do
    association :manga, factory: :manga
    association :volume, factory: :volume
    titles { { en_jp: Faker::Name.name } }
    canonical_title { 'en_jp' }
    description { { en: Faker::Lorem.paragraph(4) } }
    length { rand(20..60) }
    published { Faker::Date.between(20.years.ago, Date.today) }
    volume_number { rand(1..10) }
    sequence(:number)
  end
end
