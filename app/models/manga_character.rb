class MangaCharacter < ApplicationRecord
  enum role: %i[main supporting]

  belongs_to :manga, required: true
  belongs_to :character, required: true
end
