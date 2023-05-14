# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatWorker do
  describe '#perform' do
    it 'sends to the stat class with a wrapper around the model and changes' do
      stub_const('Stat::Test', spy)
      allow(Stat::Test).to receive(:for_user).and_return(Stat::Test)
      allow(Stat::Test).to receive(:lock!)
      allow(Stat::Test).to receive(:save!)
      allow(Stat::Test).to receive(:recalculated_at).and_return(5.years.ago)
      allow(User).to receive(:exists?).and_return(true)
      stub_const('TestModel', OpenStruct)

      described_class.new.perform('Stat::Test', 5554, 'update', {
        'class' => 'TestModel',
        'attributes' => { foo: 'bar', updated_at: 2.weeks.ago }
      }, baz: %w[bar bat])

      expect(Stat::Test).to have_received(:on_update) do |wrapper|
        expect(wrapper).to respond_to(:foo)
        expect(wrapper.foo).to eq('bar')
        expect(wrapper.baz_was).to eq('bar')
        expect(wrapper.baz).to eq('bat')
      end
    end
  end
end
