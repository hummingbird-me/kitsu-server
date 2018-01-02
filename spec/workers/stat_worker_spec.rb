require 'rails_helper'

RSpec.describe StatWorker do
  describe '#perform' do
    it 'should send to the stat class with a wrapper around the model and changes' do
      stub_const('Stat::Test', double)
      allow(Stat::Test).to receive_message_chain(:for_user, :lock!) { Stat::Test }
      stub_const('TestModel', OpenStruct)

      expect(Stat::Test).to receive(:on_update) do |wrapper|
        expect(wrapper).to respond_to(:foo)
        expect(wrapper.foo).to eq('bar')
        expect(wrapper.baz_was).to eq('bar')
        expect(wrapper.baz).to eq('bat')
      end
      StatWorker.new.perform('Stat::Test', 5554, 'update', {
        'class' => 'TestModel',
        'attributes' => { foo: 'bar' }
      }, baz: %w[bar bat])
    end
  end
end
