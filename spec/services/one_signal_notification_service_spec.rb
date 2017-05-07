require 'rails_helper'

RSpec.describe OneSignalNotificationService do
  before do
    allow_any_instance_of(described_class).to receive(:app_id).and_return('APP_ID')
  end

  describe '#request_json' do
    context 'without extra preconfiguration' do
      let!(:players) { FactoryGirl.create_list(:user, 2, :subscribed_to_one_signal) }
      let(:player_ids) { players.map { |p| p&.one_signal_id }.compact }
      let(:service) { OneSignalNotificationService.new({ en: 'English message' }, player_ids) }

      it 'should have APP ID' do
        expect(service.request_json[:app_id]).to eq('APP_ID')
      end

      it 'should have content' do
        expect(service.request_json[:content]).to eq({ en: 'English message' })
      end

      it 'should have included player ids' do
        expect(service.request_json[:include_player_ids]).to eq(player_ids)
      end
    end
  end

  describe '#notify_players!' do
    let!(:players) { FactoryGirl.create_list(:user, 4, :subscribed_to_one_signal) }
    let(:player_ids) { players.map { |p| p&.one_signal_id }.compact }
    let(:service) { OneSignalNotificationService.new({ en: 'English message' }, player_ids) }

    before do
      allow_any_instance_of(described_class).to receive(:api_key).and_return('API KEY')
    end

    context 'notifications sent without errors' do
      before do
        stub_request(:post, "#{described_class::ONE_SIGNAL_URL}/v1/notifications")
        .to_return(status: 200, body: {
            "id": "458dcec4-cf53-11e3-add2-000c2940e62c",
            "recipients": 3
        }.to_json)
      end

      it 'should trigger invalid check method' do
        expect(service).to receive(:check_and_process_invalids)
        service.notify_players!
      end
    end

    context 'notifications sent with 400 error' do
      before do
        stub_request(:post, "#{described_class::ONE_SIGNAL_URL}/v1/notifications")
        .to_return(status: 400, body: {
          "errors": ["Notification content must not be null for any languages."]
        }.to_json)
      end

      it 'should not trigger invalid check method' do
        expect(service).not_to receive(:check_and_process_invalids)
        service.notify_players!
      end
    end
  end

  describe '#check_and_process_invalids' do
    let!(:players) { FactoryGirl.create_list(:user, 4, :subscribed_to_one_signal) }
    let(:player_ids) { players.map { |p| p&.one_signal_id }.compact }
    let(:service) { OneSignalNotificationService.new({ en: 'English message' }, player_ids) }

    context 'with some invalid ids' do
      before do
        service.send(:check_and_process_invalids, {
          errors: {
            invalid_player_ids: player_ids
          }
        })
        players.each(&:reload)
      end

      it 'should remove the one signal id from the user' do
        expect(players.first(2).map { |p| p&.one_signal_id }.compact).to eq([])
      end
    end

    context 'when all player ids are invalid' do
      before do
        service.send(:check_and_process_invalids, {
          errors: ["All included players are not subscribed"]
        })
        players.each(&:reload)
      end

      it 'should remove the one signal id from the user' do
        expect(players.map { |p| p&.one_signal_id }.compact).to eq([])
      end
    end
  end
end