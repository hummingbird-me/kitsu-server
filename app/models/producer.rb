class Producer < ApplicationRecord
  include Mappable
  extend FriendlyId

  friendly_id :name, use: %i[slugged finders history]

  has_many :anime_productions
  has_many :anime, through: :anime_productions
  has_many :productions, class_name: 'MediaProduction', foreign_key: 'company_id'
end
