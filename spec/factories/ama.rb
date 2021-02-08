# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: amas
#
#  id                    :integer          not null, primary key
#  ama_subscribers_count :integer          default(0), not null
#  description           :string           not null
#  end_date              :datetime         not null
#  start_date            :datetime         not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  author_id             :integer          not null, indexed
#  original_post_id      :integer          not null, indexed
#
# Indexes
#
#  index_amas_on_author_id         (author_id)
#  index_amas_on_original_post_id  (original_post_id)
#
# Foreign Keys
#
#  fk_rails_be5e31a286  (author_id => users.id)
#  fk_rails_ef2f48b4b8  (original_post_id => posts.id)
#
# rubocop:enable Metrics/LineLength

FactoryBot.define do
  factory :ama do
    start_date { Time.now }
    description { { en: Faker::Lorem.sentence } }
    association :author, factory: :user
    association :original_post, factory: :post
  end
end
