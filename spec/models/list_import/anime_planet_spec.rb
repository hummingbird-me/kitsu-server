# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: list_imports
#
#  id                      :integer          not null, primary key
#  error_message           :text
#  error_trace             :text
#  input_file_content_type :string
#  input_file_file_name    :string
#  input_file_file_size    :integer
#  input_file_updated_at   :datetime
#  input_text              :text
#  progress                :integer
#  status                  :integer          default(0), not null
#  strategy                :integer          not null
#  total                   :integer
#  type                    :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer          not null
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe ListImport::AnimePlanet do
  before do
    host = described_class::ANIME_PLANET_HOST
    extensions = '?mylist_view=grid&per_page=480&sort=title&page='

    # Page 1 Toy
    stub_request(:get, "#{host}toyhammered/anime#{extensions}1")
      .to_return(body: fixture('list_import/anime_planet/toy-anime.html'))
    stub_request(:get, "#{host}toyhammered/manga#{extensions}1")
      .to_return(body: fixture('list_import/anime_planet/toy-manga.html'))

    # Page 2 Toy
    stub_request(:get, "#{host}toyhammered/anime#{extensions}2")
      .to_return(body: fixture('list_import/anime_planet/toy-anime.html'))

    # Page 1 Sierra
    stub_request(:get, "#{host}sierrawithas/anime#{extensions}1")
      .to_return(body: fixture('list_import/anime_planet/sierra-anime.html'))
    stub_request(:get, "#{host}sierrawithas/manga#{extensions}1")
      .to_return(body: fixture('list_import/anime_planet/sierra-manga.html'))
  end

  describe 'validations' do
    before { stub_request(:get, %r{.*/anime.*}) }

    it { should validate_presence_of(:input_text) }
    it { should validate_length_of(:input_text).is_at_least(3).is_at_most(20) }
  end

  context 'with a list' do
    subject do
      ListImport::AnimePlanet.create(
        input_text: 'toyhammered',
        user: build(:user)
      )
    end

    describe '#count' do
      it 'should return the total number of entries' do
        expect(subject.count).to eq(676)
      end
    end

    describe '#each' do
      it 'should yield exactly 47 times' do
        anime = build(:anime)
        allow(Mapping).to receive(:guess).and_return(anime)
        subject = ListImport::AnimePlanet.create(
          input_text: 'sierrawithas',
          user: build(:user)
        )
        expect { |b|
          subject.each(&b)
        }.to yield_control.exactly(47)
      end
    end
  end
end
