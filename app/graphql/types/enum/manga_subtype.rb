# frozen_string_literal: true

class Types::Enum::MangaSubtype < Types::Enum::Base
  MANHUA = 'Chinese comics produced in China and in the Greater China region.'

  value 'MANGA', value: 'manga'
  value 'NOVEL', value: 'novel'
  value 'MANHUA', MANHUA, value: 'manhua'
  value 'ONESHOT', value: 'oneshot'
  value 'DOUJIN', 'Self published work.', value: 'doujin'
  value 'MANHWA', 'A style of South Korean comic books and graphic novels', value: 'manhwa'
  value 'OEL', 'Original English Language.', value: 'oel'
end
