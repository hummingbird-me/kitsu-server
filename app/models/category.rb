# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: categories
#
#  id                 :integer          not null, primary key
#  child_count        :integer          default(0), not null
#  description        :string
#  image_content_type :string
#  image_file_name    :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  nsfw               :boolean          default(FALSE), not null
#  slug               :string           not null, indexed
#  title              :string           not null
#  total_media_count  :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  anidb_id           :integer          indexed
#  parent_id          :integer          indexed
#
# Indexes
#
#  index_categories_on_anidb_id   (anidb_id)
#  index_categories_on_parent_id  (parent_id)
#  index_categories_on_slug       (slug)
#
# rubocop:enable Metrics/LineLength

class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: %i[slugged finders history]
  resourcify

  has_many :category_favorite, dependent: :destroy
  has_attached_file :image, styles: {
    tiny: ['110x156#', :jpg],
    small: ['284x402#', :jpg],
    medium: ['390x554#', :jpg],
    large: ['550x780#', :jpg]
  }, convert_options: {
    tiny: '-quality 90 -strip',
    small: '-quality 75 -strip',
    medium: '-quality 70 -strip',
    large: '-quality 60 -strip'
  }
  has_and_belongs_to_many :anime
  has_and_belongs_to_many :manga
  has_and_belongs_to_many :drama
  belongs_to :parent, class_name: 'Category', required: false,
                      touch: true, counter_cache: 'child_count'
  has_many :children, class_name: 'Category',
                      foreign_key: 'parent_id', dependent: :destroy

  validates_attachment :image, content_type: {
    content_type: %w[image/jpg image/jpeg image/png]
  }
  validates :title, presence: true
end
