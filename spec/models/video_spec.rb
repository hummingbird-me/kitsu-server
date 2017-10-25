require 'rails_helper'

RSpec.describe Video, type: :model do
  it { should belong_to(:episode) }
  it { should validate_presence_of(:episode) }
  it { should belong_to(:streamer) }
  it { should validate_presence_of(:streamer) }
  it { should validate_presence_of(:url) }

  describe '.available_in(region)' do
    it 'should filter to only videos available in the provided region' do
      create_list(:video, 2, available_regions: %w[US])
      expect(Video.available_in('NL').count).to equal(0)
      expect(Video.available_in('US').count).to equal(2)
    end
  end

  describe '#available_in?(region)' do
    it 'should return false if the video is available in the specified region' do
      video = create(:video, available_regions: %w[US])
      expect(video).not_to be_available_in('NL')
    end

    it 'should return true if the video is available in the specified region' do
      video = build(:video, available_regions: %w[US])
      expect(video).to be_available_in('US')
    end
  end
end
