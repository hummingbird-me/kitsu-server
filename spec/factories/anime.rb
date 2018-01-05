# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: anime
#
#  id                        :integer          not null, primary key
#  abbreviated_titles        :string           is an Array
#  age_rating                :integer          indexed
#  age_rating_guide          :string(255)
#  average_rating            :decimal(5, 2)    indexed
#  canonical_title           :string           default("en_jp"), not null
#  cover_image_content_type  :string(255)
#  cover_image_file_name     :string(255)
#  cover_image_file_size     :integer
#  cover_image_meta          :text
#  cover_image_processing    :boolean
#  cover_image_top_offset    :integer          default(0), not null
#  cover_image_updated_at    :datetime
#  end_date                  :date
#  episode_count             :integer
#  episode_count_guess       :integer
#  episode_length            :integer
#  favorites_count           :integer          default(0), not null
#  popularity_rank           :integer
#  poster_image_content_type :string(255)
#  poster_image_file_name    :string(255)
#  poster_image_file_size    :integer
#  poster_image_meta         :text
#  poster_image_updated_at   :datetime
#  rating_frequencies        :hstore           default({}), not null
#  rating_rank               :integer
#  slug                      :string(255)      indexed
#  start_date                :date
#  subtype                   :integer          default(1), not null
#  synopsis                  :text             default(""), not null
#  tba                       :string
#  titles                    :hstore           default({}), not null
#  user_count                :integer          default(0), not null, indexed
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  youtube_video_id          :string(255)
#
# Indexes
#
#  index_anime_on_age_rating  (age_rating)
#  index_anime_on_slug        (slug) UNIQUE
#  index_anime_on_user_count  (user_count)
#  index_anime_on_wilson_ci   (average_rating)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :anime do
    titles { { en_jp: Faker::Name.name } }
    canonical_title 'en_jp'
    average_rating { rand(1.0..100.0) }
    subtype { Anime.subtypes.keys.sample }
    age_rating 'G'
    episode_length 24
    start_date { Faker::Date.backward(10_000) }

    trait :nsfw do
      age_rating 'R18'
    end

    trait :categories do
      transient do
        amount 5
      end

      after(:create) do |anime, evaluator|
        anime.categories = create_list(:category, evaluator.amount)
      end
    end

    trait :with_episodes do
      after(:create) do |anime|
        anime.episodes = create_list(:episode, anime.episode_count)
      end
    end
  end
end
