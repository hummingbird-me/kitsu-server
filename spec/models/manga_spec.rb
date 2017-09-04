# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: manga
#
#  id                        :integer          not null, primary key
#  abbreviated_titles        :string           is an Array
#  age_rating                :integer
#  age_rating_guide          :string
#  average_rating            :decimal(5, 2)
#  canonical_title           :string           default("en_jp"), not null
#  chapter_count             :integer
#  chapter_count_guess       :integer
#  cover_image_content_type  :string(255)
#  cover_image_file_name     :string(255)
#  cover_image_file_size     :integer
#  cover_image_meta          :text
#  cover_image_processing    :boolean
#  cover_image_top_offset    :integer          default(0)
#  cover_image_updated_at    :datetime
#  end_date                  :date
#  favorites_count           :integer          default(0), not null
#  popularity_rank           :integer
#  poster_image_content_type :string(255)
#  poster_image_file_name    :string(255)
#  poster_image_file_size    :integer
#  poster_image_meta         :text
#  poster_image_updated_at   :datetime
#  rating_frequencies        :hstore           default({}), not null
#  rating_rank               :integer
#  serialization             :string(255)
#  slug                      :string(255)
#  start_date                :date
#  subtype                   :integer          default(1), not null
#  synopsis                  :text
#  tba                       :string
#  titles                    :hstore           default({}), not null
#  user_count                :integer          default(0), not null
#  volume_count              :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Manga, type: :model do
  subject { build(:manga) }
  include_examples 'media'

  context '#default_progress_limit' do
    it 'should return 5000' do
      subject.start_date = nil
      subject.end_date = nil
      expect(subject.default_progress_limit).to eq(5000)
    end
  end

  describe 'sync_chapters' do
    it 'should create chapters when chapter_count is changed' do
      create(:manga, chapter_count: 5)
      manga = Manga.last
      expect(manga.chapters.length).to eq(manga.chapter_count)
    end
  end
end
