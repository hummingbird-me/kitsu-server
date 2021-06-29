require 'rails_helper'

RSpec.describe InstancedCallbacks do
  describe '#record' do
    it 'returns the record passed in during initialization' do
      foo = double
      expect(described_class.new(foo).record).to eq(foo)
    end
  end

  describe '#options' do
    it 'wraps the initialization options as an OpenStruct' do
      opts = { foo: 'bar' }
      expect(described_class.new(nil, opts).options.foo).to eq('bar')
    end
  end

  describe '.hook' do
    describe 'defines a new method on the provided class' do
      it 'returns an instance of the callback class' do
        klass = Class.new
        described_class.hook(klass)
        instance = klass.new
        expect(instance.InstancedCallbacks).to be_a(described_class)
      end

      it 'returns the same instance when called multiple times' do
        klass = Class.new
        described_class.hook(klass)
        instance = klass.new
        expect(instance.InstancedCallbacks).to be(instance.InstancedCallbacks)
      end

      it 'uses the name of the callback subclass' do
        stub_const('TestCallbacks', Class.new(described_class))
        klass = Class.new
        TestCallbacks.hook(klass)
        instance = klass.new
        expect(instance.TestCallbacks).to be_a(TestCallbacks)
      end
    end
  end

  describe '.attach_callback' do
    it 'attaches a callback with the given name' do
      klass = class_spy(ActiveRecord::Base)
      described_class.attach_callback(klass, :before_save)
      expect(klass).to have_received(:before_save)
    end
  end

  describe '.wrap_callback' do
    it 'wraps a method call to be bound to the instance' do
      callbacks = spy(described_class)
      fake_object = spy(ActiveRecord::Base)
      allow(fake_object).to receive(:InstancedCallbacks).and_return(callbacks)
      proc = described_class.send(:wrap_callback, :before_save)
      fake_object.instance_exec(&proc)
      expect(callbacks).to have_received(:before_save)
    end
  end
end
