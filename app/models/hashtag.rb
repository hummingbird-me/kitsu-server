class Hashtag < ApplicationRecord
  enum kind: { user_created: 0, character: 1, anime: 2, aozora: 3, game: 4,
               art: 5, music: 6, review: 7, genre: 8, news: 9, event: 10, talk: 11 }

  belongs_to :item, polymorphic: true

  def self.find_or_create(name, obj = {})
    where(name: name.downcase).first_or_create({ kind: :user_created }.merge(obj))
  end
end
