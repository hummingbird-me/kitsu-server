# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: dramas_media_attributes
#
#  id                 :integer          not null, primary key
#  high_vote_count    :integer          default(0), not null
#  low_vote_count     :integer          default(0), not null
#  neutral_vote_count :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  drama_id           :integer          not null, indexed => [media_attribute_id], indexed
#  media_attribute_id :integer          not null, indexed => [drama_id], indexed
#
# Indexes
#
#  index_drama_media_attribute                          (drama_id,media_attribute_id) UNIQUE
#  index_dramas_media_attributes_on_drama_id            (drama_id)
#  index_dramas_media_attributes_on_media_attribute_id  (media_attribute_id)
#
# Foreign Keys
#
#  fk_rails_2f9d586d2c  (media_attribute_id => media_attributes.id)
#  fk_rails_396f09ea2e  (drama_id => dramas.id)
#
# rubocop:enable Metrics/LineLength

class DramasMediaAttribute < ApplicationRecord
  has_many :media_attribute_votes
  belongs_to :drama
  belongs_to :media_attribute
end
