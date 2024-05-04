# frozen_string_literal: true

RSpec.describe WithStory do
  with_model(:StoryOwner) do
    table do |t|
      t.bigint :story_id
      t.boolean :test_value
      t.timestamps
    end

    model do
      include WithStory

      with_story do
        Story.new(type: 1, data: { test_id: id, test_value: })
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

    it 'updates the story when the data changes' do
      owner = StoryOwner.create!(test_value: true)
      expect(owner.story.reload.data['test_value']).to eq(true)
      owner.update(test_value: false)
      expect(owner.story.reload.data['test_value']).to eq(false)
    end

    it 'does not update the story when the data does not change' do
      owner = StoryOwner.create!(test_value: true)
      expect(owner.story).to receive(:update!).never
      owner.touch
    end

    it 'copies the creation timestamp to the story' do
      owner = StoryOwner.create!
      expect(owner.story.created_at).to eq(owner.created_at)
    end
  end
end
