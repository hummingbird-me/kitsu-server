# frozen_string_literal: true

RSpec.describe WithStory do
  with_model(:StoryOwner) do
    table do |t|
      t.bigint :story_id
      t.timestamps
    end

    model do
      include WithStory

      with_story do
        Story.new(type: 1, data: { test_id: id })
      end
    end
  end

  describe '.with_story' do
    it 'adds a #story association' do
      expect(StoryOwner.new).to belong_to(:story).optional.dependent(:destroy)
    end

    it 'creates a story when the record is created' do
      expect { StoryOwner.create! }.to change(Story, :count).by(1)
    end

    it 'copies the creation timestamp to the story' do
      owner = StoryOwner.create!
      expect(owner.story.created_at).to eq(owner.created_at)
    end
  end
end
