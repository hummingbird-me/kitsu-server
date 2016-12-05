# == Schema Information
#
# Table name: reviews
#
#  id                :integer          not null, primary key
#  content           :text             not null
#  content_formatted :text             not null
#  legacy            :boolean          default(FALSE), not null
#  likes_count       :integer          default(0), indexed
#  media_type        :string
#  progress          :integer
#  rating            :integer          not null
#  source            :string(255)
#  spoiler           :boolean          default(FALSE), not null
#  summary           :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  library_entry_id  :integer
#  media_id          :integer          not null, indexed
#  user_id           :integer          not null, indexed
#
# Indexes
#
#  index_reviews_on_likes_count  (likes_count)
#  index_reviews_on_media_id     (media_id)
#  index_reviews_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_150e554f22  (library_entry_id => library_entries.id)
#

FactoryGirl.define do
  factory :review do
    content { Faker::Lorem.paragraphs(2) }
    association :library_entry, factory: :library_entry, rating: 3.0,
      strategy: :build
    association :user, factory: :user, strategy: :build
    association :media, factory: :anime, strategy: :build
  end
end
