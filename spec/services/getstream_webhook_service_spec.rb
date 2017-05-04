require 'rails_helper'

RSpec.describe GetstreamWebhookService do
  let(:webhook_req) { fixture('getstream_webhook/new_feed_request.json') }

  describe '#actor' do
    let(:request) { JSON.parse(webhook_req).first }
    let!(:actor) { FactoryGirl.create(:user, id: 4) }

    it 'should find user base on actor id' do
      expect(GetstreamWebhookService.new(request).actor).to eq(actor)
    end
  end

  describe '#activity_targets' do
    context 'when notification is targeting a specific user' do
      let(:request) { JSON.parse(webhook_req)[3] }
      let!(:target_1) { FactoryGirl.create(:user, id: 1) }
      let!(:target_2) { FactoryGirl.create(:user, id: 2) }

      it 'should return array of user' do
        expect(GetstreamWebhookService.new(request).activity_targets.length).to eq(2)
        expect(GetstreamWebhookService.new(request).activity_targets).to include(target_1)
        expect(GetstreamWebhookService.new(request).activity_targets).to include(target_2)
      end
    end
  end
end