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

require 'rails_helper'

RSpec.describe GroupCategory, type: :model do
  it { should have_many(:groups).with_foreign_key('category_id') }
end
