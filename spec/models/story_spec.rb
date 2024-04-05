# frozen_string_literal: true

RSpec.describe Story do
  it 'sets bumped_at to created_at on create' do
    story = described_class.new(type: 1)
    story.save!
    expect(story.bumped_at).to eq(story.created_at)
  end

  it { is_expected.to have_many(:feed_stories).dependent(:delete_all) }

  describe '#bump!' do
    it 'updates the bumped_at timestamp on the story' do
      story = described_class.new(type: 1)
      story.save!
      Timecop.freeze(Time.now) do
        story.bump!
        expect(story.bumped_at).to eq(Time.now)
      end
    end

    it 'updates the bumped_at timestamp on the feed_stories' do
      story = described_class.create!(type: 1)
      feed = NewFeed.create!
      feed_story = FeedStory.create!(story:, feed:, bumped_at: 6.days.ago)

      time = Time.now

      expect {
        story.bump!(time)
      }.to change { feed_story.reload.bumped_at }.to be_within(0.01).of(time)
    end
  end
end
