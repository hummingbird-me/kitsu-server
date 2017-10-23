module RetrieveMedia
  extend ActiveSupport::Concern

  included do
    before_validation do
      self.media = retrieve_media
    end
  end

  def retrieve_media
    anime.presence || manga.presence || drama.presence
  end
end
