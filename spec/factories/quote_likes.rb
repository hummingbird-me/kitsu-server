# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: quote_likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quote_id   :integer          not null, indexed
#  user_id    :integer          not null, indexed
#
# Indexes
#
#  index_quote_likes_on_quote_id  (quote_id)
#  index_quote_likes_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_0e4bf2e834  (user_id => users.id)
#  fk_rails_48de98e559  (quote_id => quotes.id)
#
# rubocop:enable Metrics/LineLength

FactoryBot.define do
  factory :quote_like do
    association :user
    association :quote
  end
end
