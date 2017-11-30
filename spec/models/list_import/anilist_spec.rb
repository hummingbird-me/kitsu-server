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

RSpec.describe ListImport::Anilist do
  before do
    host = described_class::ANILIST_API
    access_token = 'RahlCEqLEgc6GPu2zBYqiGgOy2aLLZEjYridJrCO'

    # Basic Authorization
    stub_request(:post, "#{host}auth/access_token")
      .to_return(body: fixture('list_import/anilist/access_token.json'))

    # Ensure User Exists
    stub_request(:get, "#{host}user/toyhammered?access_token=#{access_token}")
      .to_return(status: 200)
    stub_request(:get, "#{host}user/nuck?access_token=#{access_token}")
      .to_return(status: 200)

    # Anime List
    stub_request(:get,
      "#{host}user/toyhammered/animelist?access_token=#{access_token}")
      .to_return(body: fixture('list_import/anilist/toy-anime.json'))

    stub_request(:get,
      "#{host}user/nuck/animelist?access_token=#{access_token}")
      .to_return(body: fixture('list_import/anilist/nuck-anime.json'))

    # Manga List
    stub_request(:get,
      "#{host}user/toyhammered/mangalist?access_token=#{access_token}")
      .to_return(body: fixture('list_import/anilist/toy-manga.json'))

    stub_request(:get,
      "#{host}user/nuck/mangalist?access_token=#{access_token}")
      .to_return(body: fixture('list_import/anilist/nuck-manga.json'))
  end

  describe 'validations' do
    before { stub_request(:get, %r{.*/user.*}) }

    it { should validate_presence_of(:input_text) }
    it { should validate_length_of(:input_text)
      .is_at_least(3)
      .is_at_most(20)
    }
  end

  context 'with a list' do
    subject do
      ListImport::Anilist.create(
        input_text: 'toyhammered',
        user: build(:user)
      )
    end

    describe '#count' do
      it 'should return the total number of entries' do
        expect(subject.count).to eq(680)
      end
    end

    describe '#each' do
      it 'should yield twice' do
        anime = build(:anime)
        allow(Mapping).to receive(:guess).and_return(anime)
        subject = ListImport::Anilist.create(
          input_text: 'nuck',
          user: build(:user)
        )
        expect { |b|
          subject.each(&b)
        }.to yield_control.exactly(2)
      end
    end
  end
end
