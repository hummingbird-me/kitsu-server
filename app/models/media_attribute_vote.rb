# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: media_attribute_votes
#
#  id                         :integer          not null, primary key
#  media_type                 :string           not null, indexed => [user_id, media_id]
#  vote                       :integer          not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  anime_media_attributes_id  :integer
#  dramas_media_attributes_id :integer
#  manga_media_attributes_id  :integer
#  media_id                   :integer          not null, indexed => [user_id, media_type]
#  user_id                    :integer          not null, indexed, indexed => [media_id, media_type]
#
# Indexes
#
#  index_media_attribute_votes_on_user_id  (user_id)
#  index_user_media_on_media_attr_votes    (user_id,media_id,media_type) UNIQUE
#
# Foreign Keys
#
#  fk_rails_39b0c09be9  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class MediaAttributeVote < ApplicationRecord
  enum vote: %i[unvoted low neutral high]
  belongs_to :user, required: true
  belongs_to :media, polymorphic: true, required: true

  belongs_to :anime_media_attributes, class_name: 'AnimeMediaAttribute'
  belongs_to :manga_media_attributes, class_name: 'MangaMediaAttribute'
  belongs_to :dramas_media_attributes, class_name: 'DramasMediaAttribute'

  counter_culture :anime_media_attributes,
    column_name: proc { |mav|
      "#{mav.vote}_vote_count" if mav.vote != 'unvoted' && mav.anime_media_attributes
    }
  counter_culture :manga_media_attributes,
    column_name: proc { |mav|
      "#{mav.vote}_vote_count" if mav.vote != 'unvoted' && mav.manga_media_attributes
    }
  counter_culture :dramas_media_attributes,
    column_name: proc { |mav|
      "#{mav.vote}_vote_count" if mav.vote != 'unvoted' && mav.dramas_media_attributes
    }

  before_validation do
    self.media = retrieve_media
  end

  def retrieve_media
    if anime_media_attributes.present?
      Anime.find_by(id: anime_media_attributes.anime_id)
    elsif manga_media_attributes.present?
      Manga.find_by(id: manga_media_attributes.manga_id)
    elsif dramas_media_attributes.present?
      Drama.find_by(id: dramas_media_attributes.drama_id)
    end
  end
end
