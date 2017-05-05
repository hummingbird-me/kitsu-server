require 'rails_helper'

RSpec.describe OneSignalNotificationService do
  describe '#request_json' do
    before do
      allow_any_instance_of(described_class).to receive(:app_id).and_return('APP_ID')
    end

    context 'without extra preconfiguration' do
      let(:players) { FactoryGirl.create_list(:user, 2) }
      let(:service) { OneSignalNotificationService.new({ en: 'English message' }, players) }

      it 'should have APP ID' do
        expect(service.request_json[:app_id]).to eq('APP_ID')
      end

      it 'should have content' do
        expect(service.request_json[:content]).to eq({ en: 'English message' })
      end

      # it 'should have included player ids' do
      #   expect(service.request_json[:include_player_ids]).to eq()
      # end
    end
  end
end