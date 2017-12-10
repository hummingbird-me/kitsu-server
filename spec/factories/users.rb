# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: users
#
#  id                          :integer          not null, primary key
#  about                       :string(500)      default(""), not null
#  about_formatted             :text
#  approved_edit_count         :integer          default(0)
#  avatar_content_type         :string(255)
#  avatar_file_name            :string(255)
#  avatar_file_size            :integer
#  avatar_meta                 :text
#  avatar_processing           :boolean
#  avatar_updated_at           :datetime
#  bio                         :string(140)      default(""), not null
#  birthday                    :date
#  comments_count              :integer          default(0), not null
#  confirmed_at                :datetime
#  country                     :string(2)
#  cover_image_content_type    :string(255)
#  cover_image_file_name       :string(255)
#  cover_image_file_size       :integer
#  cover_image_meta            :text
#  cover_image_processing      :boolean
#  cover_image_updated_at      :datetime
#  current_sign_in_at          :datetime
#  deleted_at                  :datetime
#  dropbox_secret              :string(255)
#  dropbox_token               :string(255)
#  email                       :string(255)      default(""), indexed
#  favorites_count             :integer          default(0), not null
#  feed_completed              :boolean          default(FALSE), not null
#  followers_count             :integer          default(0)
#  following_count             :integer          default(0)
#  gender                      :string
#  import_error                :string(255)
#  import_from                 :string(255)
#  import_status               :integer
#  language                    :string
#  last_backup                 :datetime
#  last_recommendations_update :datetime
#  last_sign_in_at             :datetime
#  life_spent_on_anime         :integer          default(0), not null
#  likes_given_count           :integer          default(0), not null
#  likes_received_count        :integer          default(0), not null
#  location                    :string(255)
#  mal_username                :string(255)
#  media_reactions_count       :integer          default(0), not null
#  name                        :string(255)
#  ninja_banned                :boolean          default(FALSE)
#  password_digest             :string(255)      default("")
#  past_names                  :string           default([]), not null, is an Array
#  posts_count                 :integer          default(0), not null
#  previous_email              :string
#  pro_expires_at              :datetime
#  profile_completed           :boolean          default(FALSE), not null
#  rating_system               :integer          default(0), not null
#  ratings_count               :integer          default(0), not null
#  recommendations_up_to_date  :boolean
#  rejected_edit_count         :integer          default(0)
#  remember_created_at         :datetime
#  reviews_count               :integer          default(0), not null
#  sfw_filter                  :boolean          default(TRUE)
#  share_to_global             :boolean          default(TRUE), not null
#  sign_in_count               :integer          default(0)
#  slug                        :citext           indexed
#  stripe_token                :string(255)
#  subscribed_to_newsletter    :boolean          default(TRUE)
#  theme                       :integer          default(0), not null
#  time_zone                   :string
#  title                       :string
#  title_language_preference   :string(255)      default("canonical")
#  to_follow                   :boolean          default(FALSE), indexed
#  waifu_or_husbando           :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  facebook_id                 :string(255)      indexed
#  pinned_post_id              :integer
#  pro_membership_plan_id      :integer
#  stripe_customer_id          :string(255)
#  twitter_id                  :string
#  waifu_id                    :integer          indexed
#
# Indexes
#
#  index_users_on_email        (email) UNIQUE
#  index_users_on_facebook_id  (facebook_id) UNIQUE
#  index_users_on_slug         (slug) UNIQUE
#  index_users_on_to_follow    (to_follow)
#  index_users_on_waifu_id     (waifu_id)
#
# Foreign Keys
#
#  fk_rails_bc615464bf  (pinned_post_id => posts.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :user do
    name { Faker::Internet.user_name(nil, ['_'])[0..15] + rand(1000).to_s }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :admin do
      after(:create) { |user| user.add_role(:admin) }
    end

    trait :anime_admin do
      after(:create) { |user| user.add_role(:admin, Anime) }
    end

    trait :unregistered do
      status :unregistered
      password nil
      name nil
      email nil
    end

    trait :with_avatar do
      avatar { Faker::Company.logo }
    end

    trait :subscribed_to_one_signal do
      after(:create) do |user|
        create(:one_signal_player, user: user)
      end
    end
  end
end
