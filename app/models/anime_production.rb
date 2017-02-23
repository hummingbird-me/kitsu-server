# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: anime_productions
#
#  id          :integer          not null, primary key
#  role        :integer          default(0)
#  anime_id    :integer          not null, indexed
#  producer_id :integer          not null, indexed
#
# Indexes
#
#  index_anime_productions_on_anime_id     (anime_id)
#  index_anime_productions_on_producer_id  (producer_id)
#
# rubocop:enable Metrics/LineLength

class AnimeProduction < ApplicationRecord
  has_paper_trail
  enum role: %i[producer licensor studio]

  belongs_to :anime
  belongs_to :producer
end
