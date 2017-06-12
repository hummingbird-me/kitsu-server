require 'rails_helper'

RSpec.describe ListSync::MyAnimeList::Login do
  let(:agent) { Mechanize.new }
  subject { described_class.new(agent, 'user', 'pass') }

  before do
    stub_request(:get, 'https://myanimelist.net/login.php')
      .to_return(fixture('my_anime_list/sync/login.html'))
    stub_request(:get, 'https://myanimelist.net/')
      .to_return(status: 200)
  end

  describe '#success?' do
    context 'with a good password' do
      before do
        stub_request(:post, /login\.php/)
          .to_return(status: 301, headers: {
            Location: 'https://myanimelist.net/'
          })
      end

      it 'should return true' do
        expect(subject.success?).to be true
      end

      it 'should result in a nil error_message' do
        subject.success?
        expect(subject.error_message).to be_nil
      end
    end

    context 'with invalid credentials' do
      before do
        stub_request(:post, /login\.php/)
          .to_return(fixture('my_anime_list/sync/login_failed.html'))
      end

      it 'should return false' do
        expect(subject.success?).to be false
      end

      it 'should result in an error_message from the page' do
        subject.success?
        expect(subject.error_message).to include('password is incorrect')
      end
    end
  end
end
