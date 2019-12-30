require 'rails_helper'

RSpec.describe RealEmailValidator do
  subject { described_class.new(attributes: %i[email]) }
  RecordClass = Struct.new(:email, :name) do
    extend ActiveModel::Naming
    include ActiveModel::Validations
  end

  context 'with an undeliverable email address' do
    let(:record) { RecordClass.new(email: 'invalid@fake.fake') }
    before do
      allow(Accounts::PrevalidateEmail).to receive(:call).and_return(
        OpenStruct.new(
          result: ActiveSupport::StringInquirer.new('undeliverable'),
          reason: ActiveSupport::StringInquirer.new('invalid_email')
        )
      )
    end

    it 'should add an error to each key' do
      subject.validate(record)
      expect(record.errors).to include(:email)
      expect(record.errors.count).to eq(1)
    end
  end

  context 'with an unknown email' do
    let(:record) { RecordClass.new('valid@gmail.com') }
    before do
      allow(Accounts::PrevalidateEmail).to receive(:call).and_return(
        OpenStruct.new(
          result: ActiveSupport::StringInquirer.new('unknown'),
          reason: ActiveSupport::StringInquirer.new('timeout')
        )
      )
    end

    it 'should have no errors' do
      subject.validate(record)
      expect(record.errors).to be_empty
    end
  end

  context 'with a deliverable email' do
    let(:record) { RecordClass.new('valid@gmail.com') }
    before do
      allow(Accounts::PrevalidateEmail).to receive(:call).and_return(
        OpenStruct.new(
          result: ActiveSupport::StringInquirer.new('deliverable'),
          reason: ActiveSupport::StringInquirer.new('accepted_email')
        )
      )
    end

    it 'should have no errors' do
      subject.validate(record)
      expect(record.errors).to be_empty
    end
  end

end
