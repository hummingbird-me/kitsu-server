# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: manga_media_attributes
#
#  id                 :integer          not null, primary key
#  high_vote_count    :integer          default(0), not null
#  low_vote_count     :integer          default(0), not null
#  neutral_vote_count :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  manga_id           :integer          not null, indexed => [media_attribute_id], indexed
#  media_attribute_id :integer          not null, indexed => [manga_id], indexed
#
# Indexes
#
#  index_manga_media_attribute                         (manga_id,media_attribute_id) UNIQUE
#  index_manga_media_attributes_on_manga_id            (manga_id)
#  index_manga_media_attributes_on_media_attribute_id  (media_attribute_id)
#
# Foreign Keys
#
#  fk_rails_e94250c6cb  (media_attribute_id => media_attributes.id)
#  fk_rails_f3399555e8  (manga_id => manga.id)
#
# rubocop:enable Metrics/LineLength

class MangaMediaAttribute < ApplicationRecord
  has_many :media_attribute_votes
  belongs_to :manga
  belongs_to :media_attribute
end
