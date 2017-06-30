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

require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { build(:category) }

  it { should have_and_belong_to_many(:anime) }
  it { should have_and_belong_to_many(:manga) }
  it { should have_and_belong_to_many(:drama) }
end
