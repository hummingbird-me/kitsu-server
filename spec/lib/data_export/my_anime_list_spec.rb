require 'rails_helper'

RSpec.describe DataExport::MyAnimeList do
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

  subject { described_class.new(library_entry, 'update') }

  before do
    host = described_class::ATARASHII_API_HOST
    mine = '?mine=1'

    # Authorization Check
    stub_request(:get, "#{host}account/verify_credentials")
      .to_return(body: fixture('data_export/my_anime_list/authorization_check.json'))

    # Blood Lad, this is on my list
    # authorized
    stub_request(:get, "#{host}anime/11633#{mine}")
      .to_return(body: fixture('data_export/my_anime_list/anime/blood-lad.json'))

    # Boku no Pico, this is NOT on my list
    # authorized
    stub_request(:get, "#{host}anime/1639#{mine}")
      .to_return(body: fixture('data_export/my_anime_list/anime/boku-no-pico.json'))

    # Toy's anime list (slimmed down)
    # not authorized
    stub_request(:get, "#{host}animelist/toyhammered")
      .to_return(body: fixture('data_export/my_anime_list/anime/toy-anime-list.json'))

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
      # not sure hoow to test this
      context 'Create or Update' do
        it 'returns response' do
          allow(Mapping).to receive(:lookup).and_return(mapping)
          allow(LinkedProfile).to receive(:find_by).and_return(linked_profile)

          p "Create or Update"
          subject.execute_method
        end
      end
    end

  end

  context 'Manga' do

  end
end
