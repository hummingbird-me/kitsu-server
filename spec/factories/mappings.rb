# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: mappings
#
#  id            :integer          not null, primary key
#  external_site :string           not null, indexed => [external_id, item_type, item_id]
#  item_type     :string           not null, indexed => [external_site, external_id, item_id]
#  created_at    :datetime
#  updated_at    :datetime
#  external_id   :string           not null, indexed => [external_site, item_type, item_id]
#  item_id       :integer          not null, indexed => [external_site, external_id, item_type]
#
# Indexes
#
#  index_mappings_on_external_and_item  (external_site,external_id,item_type,item_id) UNIQUE
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :mapping do
    association :item, factory: :anime, strategy: :build
    external_site 'myanimelist'
    external_id { rand(0..50_000) }
  end
end
