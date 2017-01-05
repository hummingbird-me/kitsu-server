require 'rails_helper'

RSpec.describe LinkedAccount::MyAnimeList do
  subject { described_class.new }

  before do
    host = MyAnimeListSyncService::ATARASHII_API_HOST

    stub_request(:get, "#{host}account/verify_credentials")
      .with(
        headers: {
          Authorization: 'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U='
        }
      )
      .to_return(status: 200)
  end

  context 'validates' do
    describe '#verify_mal_credentials' do
      context '#sync_to_mal?' do
        it 'should pass validation' do
          subject = described_class.new(
            sync_to: true,
            type: 'LinkedAccount::MyAnimeList'
          )
          expect(subject.sync_to_mal?).to be true
        end
        it 'should fail validation' do
          expect(subject.sync_to_mal?).to be false
        end
      end
    end
  end

end
