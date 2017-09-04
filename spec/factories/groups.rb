# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: groups
#
#  id                       :integer          not null, primary key
#  about                    :text             default(""), not null
#  avatar_content_type      :string(255)
#  avatar_file_name         :string(255)
#  avatar_file_size         :integer
#  avatar_meta              :text
#  avatar_processing        :boolean          default(FALSE), not null
#  avatar_updated_at        :datetime
#  cover_image_content_type :string(255)
#  cover_image_file_name    :string(255)
#  cover_image_file_size    :integer
#  cover_image_meta         :text
#  cover_image_updated_at   :datetime
#  featured                 :boolean          default(FALSE), not null
#  last_activity_at         :datetime
#  leaders_count            :integer          default(0), not null
#  locale                   :string
#  members_count            :integer          default(0)
#  name                     :string(255)      not null
#  neighbors_count          :integer          default(0), not null
#  nsfw                     :boolean          default(FALSE), not null
#  privacy                  :integer          default(0), not null
#  rules                    :text
#  rules_formatted          :text
#  slug                     :string(255)      not null, indexed
#  tagline                  :string(60)
#  tags                     :string           default([]), not null, is an Array
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  category_id              :integer          not null, indexed
#  pinned_post_id           :integer
#
# Indexes
#
#  index_groups_on_category_id  (category_id)
#  index_groups_on_slug         (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_a61500b09c  (category_id => group_categories.id)
#  fk_rails_ae0dbbc874  (pinned_post_id => posts.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :group do
    name { Faker::University.name }
    association :category, factory: :group_category, strategy: :build
  end
end
