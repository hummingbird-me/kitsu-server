require 'rails_helper'

RSpec.describe AttachmentValueFormatter do
  subject { AttachmentValueFormatter }
  let(:attachment) do
    Paperclip::Attachment.new(:avatar, double, styles: {
      big: 'test',
      small: 'test'
    })
  end

  context '.format' do
    context 'without attachment' do
      it 'should raise an error' do
        expect { subject.format('') }.to raise_error('Invalid attachment field')
      end
    end

    context 'with a non-empty attachment' do
      before { allow(attachment).to receive(:blank?).and_return(false) }
      let(:formatted) { subject.format(attachment) }
      it 'should not raise an error' do
        expect { formatted }.not_to raise_error
      end
      it 'should return original' do
        expect(formatted).to include(:original)
      end
      it 'should return all specified styles' do
        expect(formatted).to include(:big)
        expect(formatted).to include(:small)
      end
    end

    context 'with an empty attachment' do
      before { allow(attachment).to receive(:blank?).and_return(true) }
      let(:formatted) { subject.format(attachment) }
      it 'should not raise an error' do
        expect { formatted }.not_to raise_error
      end
      it 'should return nil' do
        expect(formatted).to be_nil
      end
    end
  end
end
