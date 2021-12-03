require 'rails_helper'

RSpec.describe ListImport::MyAnimeListXML do
  let(:file) { Fixture.new('list_import/my_anime_list/nuck.xml.gz').to_file }

  it { is_expected.to validate_absence_of(:input_text) }

  context 'with a list' do
    let(:import) do
      attachment = Shrine.upload(file, :store, metadata: false)
      attachment.metadata.merge!(
        'size' => File.size(file.path),
        'mime_type' => 'application/gzip',
        'filename' => 'test.xml.gz'
      )
      import = described_class.create(
        strategy: :greater,
        user: build(:user)
      )
      allow(import).to receive(:input_file).and_return(attachment)
      import
    end

    describe '#count' do
      it 'returns the total number of entries' do
        expect(import.count).to eq(109)
      end
    end

    describe '#each' do
      it 'yields at least 100 times' do
        anime = build(:anime)
        allow(Mapping).to receive(:guess).and_return(anime)
        expect { |b|
          import.each(&b)
        }.to yield_control.at_least(100)
      end
    end
  end
end
