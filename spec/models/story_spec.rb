# frozen_string_literal: true

RSpec.describe Story do
  it 'sets bumped_at to created_at on create' do
    story = described_class.new(type: 1)
    story.save!
    expect(story.bumped_at).to eq(story.created_at)
  end

  it { is_expected.to have_many(:feed_stories).dependent(:delete_all) }
end
