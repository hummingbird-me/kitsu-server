require 'rails_helper'

RSpec.describe ShrineAttachmentFormatter do
  let(:attachment) do
    Shrine.upload(Fixture.new('image.png').to_file, :store, metadata: false)
  end

  describe '.format' do
    context 'with an invalid attachment' do
      it 'raises an error' do
        expect { described_class.format('invalid') }.to raise_error('Invalid attachment field')
      end
    end

    context 'with a non-empty attachment' do
      let(:formatted) { described_class.format(attachment) }

      it 'does not raise an error' do
        expect { formatted }.not_to raise_error
      end

      it 'returns original' do
        expect(formatted).to include(:original)
      end
    end

    context 'with an empty attachment' do
      let(:formatted) { described_class.format(nil) }

      it 'does not raise an error' do
        expect { formatted }.not_to raise_error
      end

      it 'returns nil' do
        expect(formatted).to be_nil
      end
    end
  end
end
