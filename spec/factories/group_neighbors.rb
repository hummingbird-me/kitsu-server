# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_neighbors
#
#  id             :integer          not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  destination_id :integer          not null, indexed
#  source_id      :integer          not null, indexed
#
# Indexes
#
#  index_group_neighbors_on_destination_id  (destination_id)
#  index_group_neighbors_on_source_id       (source_id)
#
# Foreign Keys
#
#  fk_rails_0bf66d4208  (source_id => groups.id)
#  fk_rails_f61dff96a9  (destination_id => groups.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :group_neighbor do
    association :source, factory: :group
    association :destination, factory: :group
  end
end
