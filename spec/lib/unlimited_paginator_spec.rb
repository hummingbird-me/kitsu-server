require 'rails_helper'

RSpec.describe UnlimitedPaginator do
  subject { described_class.new(nil) }

  it 'raises an error when limit < 1' do
    subject.instance_variable_set(:@limit, -5)
    expect {
      subject.send(:verify_pagination_params)
    }.to raise_error(JSONAPI::Exceptions::InvalidPageValue)
  end

  it 'does not raise an error when limit is 1' do
    subject.instance_variable_set(:@limit, 1)
    expect {
      subject.send(:verify_pagination_params)
    }.not_to raise_error
  end

  it 'raises an error when offset < 0' do
    subject.instance_variable_set(:@offset, -5)
    expect {
      subject.send(:verify_pagination_params)
    }.to raise_error(JSONAPI::Exceptions::InvalidPageValue)
  end

  it 'does not raise an error when offset is 0' do
    subject.instance_variable_set(:@offset, 0)
    expect {
      subject.send(:verify_pagination_params)
    }.not_to raise_error
  end
end
