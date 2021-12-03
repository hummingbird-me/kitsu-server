require 'rails_helper'

RSpec.describe ListImport do
  class FakeImport < ListImport
    def each
      media = FactoryBot.create_list(:anime, 10)
      100.times do |i|
        yield media[i], status: :current, progress: 1
      end
    end

    def count
      10
    end

    def valid?(*)
      true
    end
  end

  subject { build(:list_import) }

  it { should define_enum_for(:status) }
  it { should belong_to(:user).required }
  it { should define_enum_for(:strategy) }
  it { should validate_presence_of(:strategy) }

  describe '#apply!' do
    let(:user) { create(:user) }
    subject do
      FakeImport.create(user: user, input_text: 'hi', strategy: :obliterate)
    end

    it 'should call #apply and update every 20 rows' do
      expect(subject).to receive(:apply) do |&block|
        100.times { |i| block.call(status: :running, progress: i) }
      end
      expect(subject).to receive(:update).exactly(5).times
      subject.apply!
    end
  end

  describe '#apply' do
    let(:user) { create(:user) }

    context 'with a proper #each method' do
      subject do
        FakeImport.create(user: user, input_text: 'hi', strategy: :greater)
      end

      it 'should yield repeatedly with the status' do
        expect { |b|
          subject.apply(&b)
        }.to yield_successive_args(*Array.new(12, Hash))
      end
    end

    context 'raising an error' do
      class ErrorFakeImport < ListImport
        def each
          raise 'An error'
        end

        def count
          7
        end

        def valid?(*)
          true
        end
      end
      subject do
        ErrorFakeImport.create(user: user, input_text: 'hi', strategy: :greater)
      end

      it 'should yield once for running and once for error' do
        expect { |b|
          subject.apply(&b)
        }.to yield_successive_args(
          { status: :running, total: 7, progress: 0 },
          { status: :failed, error_message: 'An error', error_trace: String }
        )
      end
    end
  end
end
