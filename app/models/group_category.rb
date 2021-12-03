class GroupCategory < ApplicationRecord
  include Sluggable
  include DescriptionSanitation

  friendly_id :name, use: %i[slugged finders history]
  has_many :groups, foreign_key: 'category_id'

  before_destroy do
    misc = GroupCategory.where(slug: 'misc').first
    groups.update_all(category_id: misc.id)
  end
end
