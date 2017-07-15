# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: media_attributes
#
#  id            :integer          not null, primary key
#  high_title    :string           not null
#  low_title     :string           not null
#  neutral_title :string           not null
#  slug          :string           not null, indexed
#  title         :string           not null, indexed
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_media_attributes_on_slug   (slug)
#  index_media_attributes_on_title  (title)
#
# rubocop:enable Metrics/LineLength

class MediaAttribute < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: %i[slugged finders history]
  resourcify

  has_many :anime, through: :anime_media_attributes
  has_many :anime_media_attributes
  has_many :manga, through: :manga_media_attributes
  has_many :manga_media_attributes
  has_many :drama, through: :dramas_media_attributes
  has_many :dramas_media_attributes

  validates :title, presence: true
end
