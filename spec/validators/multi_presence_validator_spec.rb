require 'rails_helper'

RSpec.describe MultiPresenceValidator do
  context 'with a minimum of 1' do
    subject { described_class.new(over: %i[foo bar baz], minimum: 1) }
    RecordClass = Struct.new(:foo, :bar, :baz) do
      extend ActiveModel::Naming
      include ActiveModel::Validations
    end

    context 'on an invalid record' do
      let(:record) { RecordClass.new }
      it 'should add an error to each key' do
        subject.validate(record)
        expect(record.errors).to include(:foo, :bar, :baz)
        expect(record.errors.count).to eq(3)
      end
    end

    context 'on a valid record' do
      let(:record) { RecordClass.new('foo') }
      it 'should have no errors' do
        subject.validate(record)
        expect(record.errors).to be_empty
      end
    end
  end

  context 'with a minimum of 3' do
    subject { described_class.new(over: %i[foo bar baz bat fud], minimum: 3) }
    RecordClass = Struct.new(:foo, :bar, :baz, :bat, :fud) do
      extend ActiveModel::Naming
      include ActiveModel::Validations
    end

    context 'on an invalid record' do
      let(:record) { RecordClass.new('foo', 'bar') }
      it 'should add an error to each key' do
        subject.validate(record)
        expect(record.errors).to include(:baz, :bat, :fud)
        expect(record.errors.count).to eq(3)
      end
    end

    context 'on a valid record' do
      let(:record) { RecordClass.new('foo', 'bar', 'baz', 'bat') }
      it 'should have no errors' do
        subject.validate(record)
        expect(record.errors).to be_empty
      end
    end
  end
end
