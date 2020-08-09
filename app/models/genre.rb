# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: genres
#
#  id          :integer          not null, primary key
#  description :text
#  name        :string(255)
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# rubocop:enable Metrics/LineLength

class Genre < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: %i[slugged finders history]
  resourcify

  has_and_belongs_to_many :anime
  has_and_belongs_to_many :manga

  before_save do
    description['en'] = Sanitize.fragment(description, Sanitize::Config::RESTRICTED)
  end
end
