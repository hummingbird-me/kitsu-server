class AnimeProduction < ApplicationRecord
  enum role: %i[producer licensor studio]

  belongs_to :anime
  belongs_to :producer
end
