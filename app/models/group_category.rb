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
end
