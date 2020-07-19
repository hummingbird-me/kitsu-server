# frozen_string_literal: true

class Types::Enum::AnimeSubtype < Types::Enum::Base
  value 'TV'
  value 'SPECIAL', 'Spinoffs or Extras of the original.', value: 'special'
  value 'OVA', 'Original Video Animation. Anime directly released to video market.'
  value 'ONA', 'Original Net Animation (Web Anime).'
  value 'MOVIE', value: 'movie'
  value 'MUSIC', value: 'music'
end
