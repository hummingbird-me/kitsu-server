module RetrieveMedia
  extend ActiveSupport::Concern

  included do
    before_validation do
      self.media = retrieve_media
    end
  end

  def retrieve_media
    if anime.present?
      anime
    elsif manga.present?
      manga
    elsif drama.present?
      drama
    end
  end
end
