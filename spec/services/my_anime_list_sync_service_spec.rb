require 'rails_helper'

RSpec.describe MyAnimeListSyncService do
  let(:library_entry) do
    build(:library_entry,
      status: 'current',
      progress: 10)
  end

  let(:linked_account) { build(:linked_account) }
  let(:mapping) do
    build(:mapping,
      external_site: 'myanimelist',
      external_id: 11_633)
  end
  let(:library_entry_log) { build(:library_entry_log) }

  # create, update, delete
  subject { described_class.new(library_entry, 'create', library_entry_log) }

  before do
    @host = described_class::ATARASHII_API_HOST
  end

  context 'Anime/Manga' do
    describe '#format_status' do
      context 'converting from kitsu -> mal' do
        it 'should change current' do
          le = build(:library_entry, status: 'current')
          expect(subject.format_status(le.status)).to eq(1)
        end
        it 'should change planned' do
          le = build(:library_entry, status: 'planned')
          expect(subject.format_status(le.status)).to eq(6)
        end
        it 'should change completed' do
          le = build(:library_entry, status: 'completed')
          expect(subject.format_status(le.status)).to eq(2)
        end
        it 'should change on_hold' do
          le = build(:library_entry, status: 'on_hold')
          expect(subject.format_status(le.status)).to eq(3)
        end
        it 'should change dropped' do
          le = build(:library_entry, status: 'dropped')
          expect(subject.format_status(le.status)).to eq(4)
        end
      end
    end

    describe '#format_score' do
      context 'converting from kitsu -> mal' do
        it 'should halve an even rating' do
          le = build(:library_entry, rating: 10)
          expect(subject.format_score(le.rating)).to eq(5)
        end
        it 'should halve and floor an odd rating' do
          le = build(:library_entry, rating: 9)
          expect(subject.format_score(le.rating)).to eq(4)
        end
        it 'should return nil if no score' do
          le = build(:library_entry, rating: nil)
          expect(subject.format_score(le.rating)).to eq(nil)
        end
      end
    end
  end

  context 'Tyhpoeus Requests' do
    describe '#get' do
      it 'should issue a request to the server' do
        stub_request(:get, "#{@host}example.com")
          .with(
            headers: {
              Authorization: 'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U='
            }
          )
          .to_return(body: 'HI')

        subject.send(:get, 'example.com', linked_account)

        expect(WebMock).to have_requested(:get, "#{@host}example.com")
          .with(
            headers: {
              Authorization: 'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U='
            }
          )
          .once
      end

      it 'should raise an error message' do
        stub_request(:get, "#{@host}example.com")
          .with(
            headers: {
              Authorization: 'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U='
            }
          )
          .to_return(status: 404)

        expect {
          subject.send(:get, 'example.com', linked_account)
        }.to raise_error(/failed/)

        expect(WebMock).to have_requested(:get, "#{@host}example.com")
          .with(
            headers: {
              Authorization: 'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U='
            }
          )
          .once
      end
    end

    describe '#post' do
      it 'should issue a request to the server' do
        stub_request(:post, "#{@host}example.com")
          .with(
            body: 'anime_id=11633&episodes=1&score&status=1',
            headers: {
              Authorization: 'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U='
            }
          )
          .to_return(status: 200)

        body = {
          anime_id: 11_633,
          status: 1,
          episodes: 1,
          score: nil
        }
        subject.send(:post, 'example.com', linked_account, body)

        expect(WebMock).to have_requested(:post, "#{@host}example.com")
          .with(
            body: 'anime_id=11633&episodes=1&score&status=1',
            headers: {
              Authorization: 'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U='
            }
          )
          .once
      end
    end

    describe '#put' do
      it 'should issue a request to the server' do
        stub_request(:put, "#{@host}example.com")
          .with(
            body: 'episodes=10&rewatch_count=0&score&status=1',
            headers: {
              Authorization: 'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U='
            }
          )
          .to_return(status: 200)

        body = {
          status: 1,
          episodes: 10,
          score: nil,
          rewatch_count: 0
        }
        subject.send(:put, 'example.com', linked_account, body)

        expect(WebMock).to have_requested(:put, "#{@host}example.com")
          .with(
            body: 'episodes=10&rewatch_count=0&score&status=1',
            headers: {
              Authorization: 'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U='
            }
          )
          .once
      end
    end

    describe '#delete' do
      it 'should issue a request to the server' do
        stub_request(:delete, "#{@host}example.com")
          .with(
            headers: {
              Authorization: 'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U='
            }
          )
          .to_return(status: 200)

        subject.send(:delete, 'example.com', linked_account)

        expect(WebMock).to have_requested(:delete, "#{@host}example.com")
          .with(
            headers: {
              Authorization: 'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U='
            }
          )
          .once
      end
    end
  end
end
