require 'rails_helper'

RSpec.describe MyAnimeListSyncService do
  let(:library_entry) do
    build(:library_entry,
      status: 'current',
      progress: 10)
  end

  let(:linked_profile) do
    build(:linked_profile,
      url: 'myanimelist',
      external_user_id: 'toyhammered',
      token: 'fakefake')
  end

  let(:mapping) do
    build(:mapping,
      external_site: 'myanimelist',
      external_id: 11_633)
  end

  # delete or create/update
  subject { described_class.new(library_entry, 'create/update') }

  before do
    host = described_class::ATARASHII_API_HOST
    mine = '?mine=1'

    # Blood Lad, this is on my list
    # authorized
    stub_request(:get, "#{host}anime/11633#{mine}")
      .to_return(body: fixture('my_anime_list/sync/anime/blood-lad.json'))

    # Boku no Pico, this is NOT on my list
    # authorized
    stub_request(:get, "#{host}anime/1639#{mine}")
      .to_return(body: fixture('my_anime_list/sync/anime/boku-no-pico.json'))

    # Toy's anime list (slimmed down)
    # not authorized
    stub_request(:get, "#{host}animelist/toyhammered")
      .to_return(body: fixture('my_anime_list/sync/anime/toy-anime-list.json'))

    # PUT request
    stub_request(:put, "#{host}animelist/anime/11633")
      .with(
        body: 'episodes=10&rewatch_count=0&score&status=1',
        headers: {
          Authorization: 'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U='
        })
      .to_return(status: 200)

    # POST request
    stub_request(:post, "#{host}animelist/anime")
      .with(
        body: 'anime_id=11633&episodes=10&score&status=1',
        headers: {
          Authorization: 'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U='
        })
      .to_return(status: 200)
  end

  context 'Anime' do
  end

  context 'Manga' do
  end

  context 'Tyhpoeus Requests' do
    describe '#get' do
      # it 'should issue a request to the server' do
      #   stub_request(:get, 'example.com', linked_profile).to_return(body: 'HI')
      #   expect { |b|
      #     subject.send(:get, 'example.com', linked_profile)
      #     subject.run
      #   }.to yield_with_args('HI')
        # expect(WebMock).to have_requested(:get, 'example.com', linked_profile).once
      # end
    end

    context 'which returns an error' do
      # it 'should output a message and never call the block' do
      #   stub_request(:get, 'example.com', linked_profile).to_return(status: 404)
      #   expect { |b|
      #     subject.send(:get, 'example.com', linked_profile, &b)
      #     subject.run
      #   }.not_to yield_control
      #   expect(WebMock).to have_requested(:get, 'example.com').once
      # end
    end
  end
end
