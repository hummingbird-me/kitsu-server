class Hashtag < ApplicationRecord
  enum kind: %i[user_created character anime aozora game art music review genre news event talk]

  belongs_to :item, polymorphic: true

  def self.find_or_create(name, obj = {})
    where(name: name.downcase).first_or_create({ kind: :user_created }.merge(obj))
  end
end
