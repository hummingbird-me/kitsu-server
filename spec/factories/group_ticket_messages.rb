# == Schema Information
#
# Table name: group_ticket_messages
#
#  id                :integer          not null, primary key
#  content           :text             not null
#  content_formatted :text             not null
#  kind              :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  ticket_id         :integer          not null, indexed
#  user_id           :integer          not null
#
# Indexes
#
#  index_group_ticket_messages_on_ticket_id  (ticket_id)
#
# Foreign Keys
#
#  fk_rails_e77fcefb97  (ticket_id => group_tickets.id)
#

FactoryGirl.define do
  factory :group_ticket_message do
    association :ticket, strategy: :build
    association :user, strategy: :build
    content { Faker::Lorem.sentence }
  end
end
