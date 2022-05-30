class MangaCharacter < ApplicationRecord
  enum role: { main: 0, supporting: 1 }

  belongs_to :manga, optional: false
  belongs_to :character, optional: false
end
