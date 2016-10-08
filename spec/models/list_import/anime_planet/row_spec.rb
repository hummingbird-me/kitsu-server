require 'rails_helper'

RSpec.describe ListImport::AnimePlanet::Row do
  let(:anime) { fixture('list_import/anime_planet/toy-anime.html') }
  let(:manga) { fixture('list_import/anime_planet/toy-manga.html') }

  subject { described_class.new(
    Nokogiri::HTML(anime).css('table.personalList tr')[1]
  )}

  context 'Anime' do
    describe '#media_info' do
      it 'should return the title' do
        expect(subject.media_info[:title]).to eq('07-Ghost')
      end
    end
  end

  context 'Manga' do

  end
end
