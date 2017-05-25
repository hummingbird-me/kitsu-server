# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: list_imports
#
#  id                      :integer          not null, primary key
#  error_message           :text
#  error_trace             :text
#  input_file_content_type :string
#  input_file_file_name    :string
#  input_file_file_size    :integer
#  input_file_updated_at   :datetime
#  input_text              :text
#  progress                :integer
#  status                  :integer          default(0), not null
#  strategy                :integer          not null
#  total                   :integer
#  type                    :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer          not null
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe ListImport do
  class FakeImport < ListImport
    def each
      media = FactoryGirl.create_list(:anime, 10)
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
  it { should belong_to(:user).touch }
  it { should validate_presence_of(:user) }
  it { should define_enum_for(:strategy) }
  it { should validate_presence_of(:strategy) }
  it { should have_attached_file(:input_file) }

  context 'without input_file' do
    subject { build(:list_import, input_file: nil) }
    it { should validate_presence_of(:input_text) }
  end
  context 'without input_text' do
    subject { build(:list_import, input_text: nil) }
    it { should validate_presence_of(:input_file) }
  end

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
          { status: :failed, total: 7, error_message: 'An error', error_trace: String }
        )
      end
    end
  end
end
