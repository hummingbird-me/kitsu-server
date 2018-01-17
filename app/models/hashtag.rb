# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: hashtags
#
#  id         :integer          not null, primary key
#  item_type  :string
#  kind       :integer          default(0), not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_id    :integer
#
# rubocop:enable Metrics/LineLength

class Hashtag < ApplicationRecord
  enum kind: %i[user_created character anime aozora game art music review genre news event talk]

  belongs_to :item, polymorphic: true

  def self.find_or_create(name, obj = {})
    where(name: name.downcase).first_or_create({ kind: :user_created }.merge(obj))
  end
end
