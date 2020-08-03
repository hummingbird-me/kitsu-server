require 'rails_helper'

RSpec.shared_examples 'streamable' do
  # Columns which are mandatory for all streamables
  it { should have_db_column(:regions).of_type(:string) }
  it { should have_db_column(:dubs).of_type(:string) }
  it { should have_db_column(:subs).of_type(:string) }

  it { should belong_to(:streamer).required }

  it { should validate_presence_of(:streamer) }
  it { should validate_presence_of(:subs) }
  it { should validate_presence_of(:dubs) }

  it { should respond_to(:available_in?) }

  let(:factory_type) { described_class.name.underscore.to_sym }

  describe '.available_in(region)' do
    # rubocop:disable Metrics/LineLength
    it "should filter to only include #{described_class} records available in the provided region" do
      create_list(factory_type, 2, regions: %w[US])
      expect(described_class.available_in('NL').count).to equal(0)
      expect(described_class.available_in('US').count).to equal(2)
    end
    # rubocop:enable Metrics/LineLength
  end

  describe '#available_in?(region)' do
    # rubocop:disable Metrics/LineLength
    it "should return false if the #{described_class} record is not available in the specified region" do
      record = create(factory_type, regions: %w[US])
      expect(record).not_to be_available_in('NL')
    end

    it "should return true if the #{described_class} record is available in the specified region" do
      record = build(factory_type, regions: %w[US])
      expect(record).to be_available_in('US')
    end
    # rubocop:enable Metrics/LineLength
  end

  describe '.dubbed(langs)' do
    it "should filter to only include #{described_class} records available in the provided dubs" do
      create_list(factory_type, 2, dubs: %w[en])
      expect(described_class.dubbed(%w[en]).count).to equal(2)
      expect(described_class.dubbed(%w[jp]).count).to equal(0)
    end
  end

  describe '.subbed(langs)' do
    it "should filter to only include #{described_class} records available in the provided subs" do
      create_list(factory_type, 2, subs: %w[en])
      expect(described_class.subbed(%w[en]).count).to equal(2)
      expect(described_class.subbed(%w[jp]).count).to equal(0)
    end
  end
end
