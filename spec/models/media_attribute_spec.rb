# == Schema Information
#
# Table name: media_attribute
#
#  id         :integer          not null, primary key
#  slug       :string           not null, indexed
#  title      :string           not null, indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_media_attribute_on_slug   (slug)
#  index_media_attribute_on_title  (title)
#

require 'rails_helper'

RSpec.describe MediaAttribute, type: :model do
  subject { build(:media_attribute) }

  it { should have_and_belong_to_many(:anime) }
  it { should have_and_belong_to_many(:manga) }
  it { should have_and_belong_to_many(:drama) }
end
