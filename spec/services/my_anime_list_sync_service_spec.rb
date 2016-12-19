require 'rails_helper'

RSpec.describe MyAnimeListSyncService do
  let(:library_entry) { build(:library_entry,
    status: 'current',
    progress: 10
  )}
  let(:linked_profile) { build(:linked_profile,
    url: 'myanimelist',
    external_user_id: 'toyhammered',
    token: 'fakefake'
  )}
  let(:mapping) { build(:mapping,
    external_site: 'myanimelist',
    external_id: 11_633
  )}

  # personalize subject per create/update/destroy
  subject { described_class.new(library_entry, 'update') }

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
      .with(:body => "episodes=10&rewatch_count=0&score&status=1",
           :headers => {'Authorization'=>'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U='})
      .to_return(status: 200, :body => "", :headers => {})

    # POST request
    stub_request(:post, "https://hbv3-mal-api.herokuapp.com/2.1/animelist/anime")
      .with(:body => "anime_id=11633&episodes=10&score&status=1",
           :headers => {'Authorization'=>'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U=' })
      .to_return(:status => 200, :body => "", :headers => {})
  end

  context 'Anime' do
    describe '#execute_method' do

    end
  end

  context 'Manga' do

  end

  context 'Tyhpoeus Requests' do
    describe 'getting a url' do
      # it 'should issue a request to the server' do
      #   stub_request(:get, 'example.com', linked_profile).to_return(body: 'HULLO')
      #   expect { |b|
      #     subject.send(:get, 'example.com', linked_profile, &b)
      #     subject.run
      #   }.to yield_with_args('HULLO')
      #   expect(WebMock).to have_requested(:get, 'example.com').once
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
