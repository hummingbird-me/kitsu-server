# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: linked_sites
#
#  id         :integer          not null, primary key
#  link_type  :integer          not null
#  name       :string           not null
#  share_from :boolean          default(FALSE), not null
#  share_to   :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :linked_site do
    name { Faker::Company.name }
    link_type { LinkedSite.link_types.keys.sample }
  end
end
