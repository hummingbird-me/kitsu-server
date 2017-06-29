# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: media_attributes
#
#  id            :integer          not null, primary key
#  high_title    :string           not null
#  low_title     :string           not null
#  neutral_title :string           not null
#  slug          :string           not null, indexed
#  title         :string           not null, indexed
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_media_attributes_on_slug   (slug)
#  index_media_attributes_on_title  (title)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe MediaAttribute, type: :model do
  subject { build(:media_attribute) }

  it { should have_many(:anime) }
  it { should have_many(:manga) }
  it { should have_many(:drama) }
end
