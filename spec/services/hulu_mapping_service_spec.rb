require 'rails_helper'

RSpec.describe HuluMappingService do
  shared_examples_for 'default config' do
    it 'since offset should not be nil' do
      expect(service.since).not_to eq(nil)
    end
  end

  describe 'with daily update initialization' do
    context 'mocking call from worker' do
      let(:service) do
        HuluMappingService.new(Time.now)
      end
      it_should_behave_like 'default config'
    end
  end
end
