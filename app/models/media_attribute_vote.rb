class MediaAttributeVote < ApplicationRecord
  enum vote: { unvoted: 0, low: 1, neutral: 2, high: 3 }
  belongs_to :user, optional: false
  belongs_to :media, polymorphic: true, optional: false

  belongs_to :anime_media_attributes, class_name: 'AnimeMediaAttribute', optional: true
  belongs_to :manga_media_attributes, class_name: 'MangaMediaAttribute', optional: true
  belongs_to :dramas_media_attributes, class_name: 'DramasMediaAttribute', optional: true

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
