# == Schema Information
#
# Table name: chapters
#
#  id              :integer          not null, primary key
#  canonical_title :string           default("en_jp"), not null
#  length          :integer
#  number          :integer          not null
#  published       :date
#  synopsis        :text
#  titles          :hstore           default({}), not null
#  volume          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  manga_id        :integer          indexed
#
# Indexes
#
#  index_chapters_on_manga_id  (manga_id)
#

class Chapter < ActiveRecord::Base
  belongs_to :manga

  validates :manga, presence: true
  validates :number, presence: true
end
