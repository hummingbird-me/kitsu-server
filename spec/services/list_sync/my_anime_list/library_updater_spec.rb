require 'rails_helper'

RSpec.describe ListSync::MyAnimeList::LibraryUpdater do
  let(:agent) { Mechanize.new }
  let(:mapping) { OpenStruct.new(external_id: '123') }
  let(:library_entry) do
    create(:library_entry, media: media, rating: 9, started_at: 5.days.ago,
                           finished_at: 2.hours.ago)
  end
  subject { described_class.new(agent, library_entry) }

  before do
    allow(media).to receive(:mapping_for).and_return(mapping)
  end

  describe '#run!' do
    context 'to edit manga' do
      let(:media) { build(:manga) }
      before do
        stub_request(:get, /ownlist.*edit/)
          .to_return(fixture('my_anime_list/sync/edit_manga.html'))
        stub_request(:post, /ownlist.*edit/)
          .to_return(fixture('my_anime_list/sync/update_success.html'))
      end

      context 'without authentication' do
        before do
          stub_request(:get, /ownlist.*edit/)
            .to_return(status: 303, headers: {
              Location: 'https://myanimelist.net/login.php'
            })
          stub_request(:get, 'https://myanimelist.net/login.php')
            .to_return(fixture('my_anime_list/sync/login.html'))
        end

        it 'should raise ListSync::AuthenticationError' do
          expect { subject.run! }.to raise_error(ListSync::AuthenticationError)
        end
      end

      context 'with authentication' do
        it 'should return true' do
          expect(subject.run!).to be true
        end
      end

      context 'with an error' do
        before do
          stub_request(:post, /ownlist.*edit/)
            .to_return(fixture('my_anime_list/sync/update_failed.html'))
        end

        it 'should raise ListSync::RemoteError' do
          expect { subject.run! }.to raise_error(ListSync::RemoteError)
        end
      end
    end

    context 'to add anime' do
      let(:media) { build(:anime) }
      before do
        stub_request(:get, /ownlist.*edit/)
          .to_return(fixture('my_anime_list/sync/add_anime.html'))
        stub_request(:post, /ownlist.*edit/)
          .to_return(fixture('my_anime_list/sync/update_success.html'))
      end

      context 'with authentication' do
        it 'should return true' do
          expect(subject.run!).to be true
        end
      end
    end
  end
end
