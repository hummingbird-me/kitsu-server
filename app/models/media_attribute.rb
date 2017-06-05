# == Schema Information
#
# Table name: media_attribute
#
#  id                 :integer          not null, primary key
#  high_vote_count    :integer          default(0), not null
#  low_vote_count     :integer          default(0), not null
#  neutral_vote_count :integer          default(0), not null
#  slug               :string           not null, indexed
#  title              :string           not null, indexed
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_media_attribute_on_slug   (slug)
#  index_media_attribute_on_title  (title)
#

class MediaAttribute < ActiveRecord::Base
  self.table_name = 'media_attribute'
  extend FriendlyId
  friendly_id :title, use: %i[slugged finders history]
  resourcify

  has_and_belongs_to_many :anime, join_table: 'anime_media_attributes'
  has_and_belongs_to_many :manga, join_table: 'manga_media_attributes'
  has_and_belongs_to_many :drama, join_table: 'dramas_media_attributes'
  has_many :media_attribute_vote, dependent: :destroy

  validates :title, presence: true
end
