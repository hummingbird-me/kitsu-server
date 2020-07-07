# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: producers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# rubocop:enable Metrics/LineLength

class Producer < ApplicationRecord
  include Mappable
  extend FriendlyId

  friendly_id :name, use: %i[slugged finders history]

  has_many :anime_productions
  has_many :anime, through: :anime_productions
  has_many :productions, class_name: 'MediaProduction', foreign_key: 'company_id'
end
