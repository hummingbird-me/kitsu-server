require 'rails_helper'

RSpec.describe CountryCodeValidator do
  subject { described_class.new(attributes: %i[country]) }

  record_class = Struct.new(:country) do
    extend ActiveModel::Naming
    include ActiveModel::Validations
  end

  context 'with a single country code' do
    context 'on an invalid record' do
      let(:record) { record_class.new('**') }

      it 'adds an error' do
        subject.validate(record)
        expect(record.errors).to include(:country)
        expect(record.errors.count).to eq(1)
      end
    end

    context 'on a valid record' do
      let(:record) { record_class.new('us') }

      it 'has no errors' do
        subject.validate(record)
        expect(record.errors).to be_empty
      end
    end
  end

  context 'with a list of country codes' do
    context 'on a completely invalid list' do
      let(:record) { record_class.new(['**', '__', '&&']) }

      it 'adds an error for each invalid item' do
        subject.validate(record)
        expect(record.errors).to include(:country)
        expect(record.errors.count).to eq(3)
      end
    end

    context 'on a partially invalid list' do
      let(:record) { record_class.new(['us', '&&', 'fr', '__', 'ru']) }

      it 'adds an error for each invalid item' do
        subject.validate(record)
        expect(record.errors).to include(:country)
        expect(record.errors.count).to eq(2)
      end
    end

    context 'on a fully valid list' do
      let(:record) { record_class.new(%w[us fr ru]) }

      it 'has no errors' do
        subject.validate(record)
        expect(record.errors).to be_empty
      end
    end
  end
end
