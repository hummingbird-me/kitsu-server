class AnimeProduction < ApplicationRecord
  enum role: { producer: 0, licensor: 1, studio: 2 }

  belongs_to :anime
  belongs_to :producer
end
