# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_categories
#
#  id          :integer          not null, primary key
#  description :text
#  name        :string           not null
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# rubocop:enable Metrics/LineLength

class GroupCategory < ApplicationRecord
  include Sluggable

  friendly_id :name, use: %i[slugged finders history]
  has_many :groups, foreign_key: 'category_id'

  before_destroy do
    misc = GroupCategory.where(slug: 'misc').first
    groups.update_all(category_id: misc.id)
  end
end
