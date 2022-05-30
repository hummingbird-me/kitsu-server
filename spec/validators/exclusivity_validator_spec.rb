require 'rails_helper'

RSpec.describe ExclusivityValidator do
  context 'with a limit of 1' do
    subject { described_class.new(over: %i[foo bar baz], limit: 1) }

    record_class = Struct.new(:foo, :bar, :baz) do
      extend ActiveModel::Naming
      include ActiveModel::Validations
    end

    context 'on an invalid record' do
      let(:record) { record_class.new('foo', 'bar') }

      it 'adds an error to each key' do
        subject.validate(record)
        expect(record.errors).to include(:foo, :bar)
        expect(record.errors.count).to eq(2)
      end
    end

    context 'on a valid record' do
      let(:record) { record_class.new('foo') }

      it 'has no errors' do
        subject.validate(record)
        expect(record.errors).to be_empty
      end
    end
  end

  context 'with a limit of 3' do
    subject { described_class.new(over: %i[foo bar baz bat fud], limit: 3) }

    record_class = Struct.new(:foo, :bar, :baz, :bat, :fud) do
      extend ActiveModel::Naming
      include ActiveModel::Validations
    end

    context 'on an invalid record' do
      let(:record) { record_class.new('foo', 'bar', 'bat', 'baz') }

      it 'adds an error to each key' do
        subject.validate(record)
        expect(record.errors).to include(:foo, :bar, :baz, :bat)
        expect(record.errors.count).to eq(4)
      end
    end

    context 'on a valid record' do
      let(:record) { record_class.new('foo') }

      it 'has no errors' do
        subject.validate(record)
        expect(record.errors).to be_empty
      end
    end
  end
end
