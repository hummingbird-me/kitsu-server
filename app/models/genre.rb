class Genre < ApplicationRecord
  include DescriptionSanitation
  extend FriendlyId
  friendly_id :name, use: %i[slugged finders history]
  resourcify

  has_and_belongs_to_many :anime
  has_and_belongs_to_many :manga
end
