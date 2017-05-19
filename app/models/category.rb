# == Schema Information
#
# Table name: categories
#
#  id                 :integer          not null, primary key
#  description        :string
#  image_content_type :string
#  image_file_name    :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  title              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  anidb_id           :integer          indexed
#  parent_id          :integer          indexed
#
# Indexes
#
#  index_categories_on_anidb_id   (anidb_id)
#  index_categories_on_parent_id  (parent_id)
#

class Category < ActiveRecord::Base
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
  belongs_to :parent, class_name: 'Category', required: false

  validates_attachment :image, content_type: {
    content_type: %w[image/jpg image/jpeg image/png]
  }
  validates :title, presence: true
end
