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
  subject { described_class.new('toyhammered') }

  before do
    host = described_class::ANIME_PLANET_HOST
    2.times do |page|
      extensions = "?mylist_view=list&per_page=480&sort=title&page=#{page + 1}"

      stub_request(:get, "#{host}toyhammered/anime#{extensions}")
        .to_return(body: fixture('list_import/anime_planet/toy-anime.html'))
      stub_request(:get, "#{host}toyhammered/manga#{extensions}")
        .to_return(body: fixture('list_import/anime_planet/toy-manga.html'))
    end
  end

  context 'with a list' do
    describe '#count' do
      it 'should return the total number of entries' do
        expect(subject.count).to eq(676)
      end
    end

    describe '#each' do
      it 'should yield atleast 100 times' do
        expect { |b|
          subject.each(&b)
        }.to yield_control.at_least(100)
      end
    end

    describe 'getting a url' do
      it 'should issue a request to the server' do
        host = described_class::ANIME_PLANET_HOST
        extensions = '?mylist_view=list&per_page=480&sort=title&page=1'

        stub_request(:get, "#{host}toyhammered/anime#{extensions}").to_return(body: 'Sexypants')

        expect(subject.get('toyhammered/anime').text).to eq('Sexypants')
      end

    end
  end
end
