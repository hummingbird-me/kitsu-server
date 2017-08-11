require 'rails_helper'

RSpec.describe OneSignalNotificationService do
  before do
    allow_any_instance_of(described_class).to receive(:app_id)
      .and_return('APP_ID')
  end

  shared_examples_for 'default config' do
    it 'should have APP ID' do
      expect(service.request_json[:app_id]).to eq('APP_ID')
    end

    it 'should have content' do
      expect(service.request_json[:content]).to eq(en: 'English message')
    end

    it 'should have included player ids' do
      expect(service.request_json[:include_player_ids]).to eq(player_ids)
    end
  end

  describe '#request_json' do
    context 'without extra preconfiguration' do
      let!(:players) do
        FactoryGirl.create_list(:user, 2, :subscribed_to_one_signal)
      end
      let(:player_ids) { players.flat_map(&:one_signal_player_ids) }
      let(:service) do
        OneSignalNotificationService.new({ en: 'English message' }, player_ids)
      end

      it_should_behave_like 'default config'
    end

    context 'with extra preconfiguration' do
      let!(:players) do
        FactoryGirl.create_list(:user, 2, :subscribed_to_one_signal)
      end
      let(:player_ids) { players.flat_map(&:one_signal_player_ids) }
      let(:service) do
        OneSignalNotificationService.new(
          { en: 'English message' },
          player_ids,
          url: 'https://kitsu.io/kitsu-256.png'
        )
      end

      it_should_behave_like 'default config'

      it 'should contains the extra config' do
        expect(service.request_json[:url]).to eq('https://kitsu.io/kitsu-256.png')
      end
    end
  end

  describe '#notify_players!' do
    let!(:players) do
      FactoryGirl.create_list(:user, 4, :subscribed_to_one_signal)
    end
    let(:player_ids) { players.flat_map(&:one_signal_player_ids) }
    let(:service) do
      OneSignalNotificationService.new({ en: 'English message' }, player_ids)
    end

    before do
      allow_any_instance_of(described_class).to receive(:api_key)
        .and_return('API KEY')
    end

    context 'notifications sent without errors' do
      before do
        stub_request(
          :post,
          "#{described_class::ONE_SIGNAL_URL}/v1/notifications"
        ).to_return(status: 200, body: {
          'id': '458dcec4-cf53-11e3-add2-000c2940e62c',
          'recipients': 3
        }.to_json)
      end

      it 'should trigger invalid check method' do
        expect(service).to receive(:check_and_process_invalids)
        service.notify_players!
      end
    end

    context 'notifications sent with 400 error' do
      before do
        stub_request(
          :post,
          "#{described_class::ONE_SIGNAL_URL}/v1/notifications"
        ).to_return(status: 400, body: {
          'errors': ['Notification content must not be null for any languages.']
        }.to_json)
      end

      it 'should raise an error' do
        expect { service.notify_players! }.to raise_error(/Bad OneSignal push/i)
      end
    end
  end

  describe '#check_and_process_invalids' do
    let!(:players) do
      FactoryGirl.create_list(:user, 4, :subscribed_to_one_signal)
    end
    let(:player_ids) { players.flat_map(&:one_signal_player_ids) }
    let(:service) do
      OneSignalNotificationService.new({ en: 'English message' }, player_ids)
    end

    context 'with some invalid ids' do
      let(:invalid_player_ids) { player_ids.first(2) }
      before do
        service.send(:check_and_process_invalids, errors: {
          invalid_player_ids: invalid_player_ids
        })
        players.each(&:reload)
      end

      it 'should remove the one signal ids from the user' do
        expect(OneSignalPlayer.where('player_id IN (?)', invalid_player_ids))
          .to be_empty
        expect(OneSignalPlayer.all).not_to be_empty
      end
    end

    context 'when all player ids are invalid' do
      before do
        service.send(:check_and_process_invalids,
          errors: ['All included players are not subscribed'])
        players.each(&:reload)
      end

      it 'should remove the one signal ids from the user' do
        expect(OneSignalPlayer.all).to be_empty
      end
    end
  end
end
