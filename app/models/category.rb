class Category < ApplicationRecord
  include Mappable
  include DescriptionSanitation
  extend FriendlyId
  friendly_id :title, use: %i[slugged finders history]
  resourcify

  has_ancestry
  has_many :category_favorite, dependent: :destroy
  has_many :media_categories
  has_many :media, through: :media_categories
  has_many :anime, through: :media_categories, source: :media, source_type: 'Anime'
  has_many :manga, through: :media_categories, source: :media, source_type: 'Manga'
  belongs_to :parent, class_name: 'Category', optional: true,
                      touch: true, counter_cache: 'child_count'
  has_many :children, class_name: 'Category',
                      foreign_key: 'parent_id', dependent: :destroy

  validates :title, presence: true
end
