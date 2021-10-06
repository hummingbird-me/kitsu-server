require 'rails_helper'

RSpec.describe WordfilterCallbacks do
  describe '.hook' do
    it 'attaches a before_validation hook' do
      klass = class_spy(Post)
      described_class.hook(klass, :location, :content_field)
      expect(klass).to have_received(:before_validation)
    end

    it 'attaches an after_save hook' do
      klass = class_spy(Post)
      described_class.hook(klass, :location, :content_field)
      expect(klass).to have_received(:after_save)
    end
  end

  describe '#before_validation' do
    let(:klass) do
      Class.new do
        include ActiveModel::Model
        attr_accessor :hidden_at, :content
      end
    end

    context 'with a hide wordfilter' do
      let(:wordfilter) do
        OpenStruct.new(censor?: false, report?: false, hide?: true, reject?: false)
      end

      it 'censors the text in the content field' do
        record = klass.new(content: 'uncensored', hidden_at: nil)
        callbacks = described_class.new(record, content_field: :content)
        allow(callbacks).to receive(:wordfilter).and_return(wordfilter)
        callbacks.before_validation
        expect(record.hidden_at).not_to be_nil
      end
    end

    context 'with a censor wordfilter' do
      let(:wordfilter) do
        OpenStruct.new(
          censor?: true,
          censored_text: 'censored',
          report?: false,
          hide?: false,
          reject?: false
        )
      end

      it 'censors the text in the content field' do
        record = klass.new(content: 'uncensored', hidden_at: nil)
        callbacks = described_class.new(record, content_field: :content)
        allow(callbacks).to receive(:wordfilter).and_return(wordfilter)
        callbacks.before_validation
        expect(record.content).to eq('censored')
      end
    end

    context 'with a reject wordfilter' do
      let(:wordfilter) do
        OpenStruct.new(censor?: false, report?: false, hide?: false, reject?: true)
      end

      it 'censors the text in the content field' do
        record = klass.new(content: 'uncensored', hidden_at: nil)
        callbacks = described_class.new(record, content_field: :content)
        allow(callbacks).to receive(:wordfilter).and_return(wordfilter)
        callbacks.before_validation
        expect(record.errors[:content]).to include('contains an inappropriate word')
      end
    end
  end

  describe '#after_save' do
    context 'with a report wordfilter' do
      let(:wordfilter) do
        OpenStruct.new(
          censor?: false,
          report?: true,
          hide?: false,
          reject?: false,
          report_reasons: []
        )
      end

      it 'censors the text in the content field' do
        report_klass = class_spy(Report)
        stub_const('Report', report_klass)
        callbacks = described_class.new({}, content_field: :content)
        allow(User).to receive(:system_user).and_return(-10)
        allow(callbacks).to receive(:wordfilter).and_return(wordfilter)

        callbacks.after_save
        expect(report_klass).to have_received(:first_or_create!)
      end
    end
  end
end
