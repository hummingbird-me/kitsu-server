# == Schema Information
#
# Table name: chapters
#
#  id              :integer          not null, primary key
#  canonical_title :string           default("en_jp"), not null
#  length          :integer
#  number          :integer          not null
#  published       :date
#  synopsis        :text
#  titles          :hstore           default({}), not null
#  volume          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  manga_id        :integer          indexed
#
# Indexes
#
#  index_chapters_on_manga_id  (manga_id)
#

require 'rails_helper'

RSpec.describe Chapter, type: :model do
  # subject { create(:chapter) }
  #
  # let(:manga) { create(:manga) }
  it { should validate_presence_of(:manga) }
  it { should validate_presence_of(:number) }
end
