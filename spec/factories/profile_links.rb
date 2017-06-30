# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: profile_links
#
#  id                   :integer          not null, primary key
#  url                  :string           not null
#  created_at           :datetime
#  updated_at           :datetime
#  profile_link_site_id :integer          not null, indexed, indexed => [user_id]
#  user_id              :integer          not null, indexed, indexed => [profile_link_site_id]
#
# Indexes
#
#  index_profile_links_on_profile_link_site_id              (profile_link_site_id)
#  index_profile_links_on_user_id                           (user_id)
#  index_profile_links_on_user_id_and_profile_link_site_id  (user_id,profile_link_site_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_16f7039808  (profile_link_site_id => profile_link_sites.id)
#  fk_rails_740c28bcae  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :profile_link do
    association :user, strategy: :build
    association :profile_link_site, strategy: :build
    url 'toyhammered'
  end
end
