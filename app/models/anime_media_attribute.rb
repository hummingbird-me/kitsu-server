# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: anime_media_attributes
#
#  id                 :integer          not null, primary key
#  high_vote_count    :integer          default(0), not null
#  low_vote_count     :integer          default(0), not null
#  neutral_vote_count :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  anime_id           :integer          not null, indexed => [media_attribute_id], indexed
#  media_attribute_id :integer          not null, indexed => [anime_id], indexed
#
# Indexes
#
#  index_anime_media_attribute                         (anime_id,media_attribute_id) UNIQUE
#  index_anime_media_attributes_on_anime_id            (anime_id)
#  index_anime_media_attributes_on_media_attribute_id  (media_attribute_id)
#
# Foreign Keys
#
#  fk_rails_88955ab592  (media_attribute_id => media_attributes.id)
#  fk_rails_c8ff37f0ab  (anime_id => anime.id)
#
# rubocop:enable Metrics/LineLength

class AnimeMediaAttribute < ApplicationRecord
  self.table_name = 'anime_media_attributes'
  has_many :media_attribute_votes
  belongs_to :media_attribute
  belongs_to :anime
end
