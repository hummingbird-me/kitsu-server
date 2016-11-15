# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: marathon_events
#
#  id          :integer          not null, primary key
#  event       :integer          not null
#  status      :integer
#  unit_type   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  marathon_id :integer          not null
#  unit_id     :integer
#
# Foreign Keys
#
#  fk_rails_43eaffb81b  (marathon_id => marathons.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :marathon_event do
    event :updated
    status :planned
    marathon
  end
end
