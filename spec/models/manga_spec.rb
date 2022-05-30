require 'rails_helper'

RSpec.describe Manga, type: :model do
  subject { build(:manga) }

  include_examples 'media'

  describe '#default_progress_limit' do
    it 'returns 5000' do
      subject.start_date = nil
      subject.end_date = nil
      expect(subject.default_progress_limit).to eq(5000)
    end
  end

  describe 'sync_chapters' do
    it 'creates chapters when chapter_count is changed' do
      create(:manga, chapter_count: 5)
      manga = Manga.last
      expect(manga.chapters.length).to eq(manga.chapter_count)
    end
  end
end
