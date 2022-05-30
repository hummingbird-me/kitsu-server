require 'rails_helper'

RSpec.describe Callbacks do
  it 'accepts record during initialization' do
    foo = double
    expect(Callbacks.new(foo).record).to eq(foo)
  end

  it 'sets default options to an empty hash' do
    expect(Callbacks.new(nil).options).to eq({})
  end

  describe '#with_options' do
    it 'generates a new anonymous class with the options set' do
      opts = Callbacks.with_options(foo: 'bar')
      expect(opts.new(nil).options[:foo]).to eq('bar')
    end
  end

  describe 'class-level hook methods' do
    it 'sends the callback to the instance' do
      test = Class.new(Callbacks) do
        def before_save; end
      end
      expect_any_instance_of(test).to receive(:before_save)
      test.before_save(:foo)
    end
  end
end
