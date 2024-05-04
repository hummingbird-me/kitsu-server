# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MediaReaction, type: :model do
  subject { build(:media_reaction) }

  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:library_entry).required }

  it { is_expected.to validate_length_of(:reaction).is_at_most(140) }
  it { is_expected.not_to allow_value('').for(:reaction) }

  it 'creates a Story', :aggregate_failures do
    reaction = create(:media_reaction)

    expect(reaction.story).to be_a(Story::MediaReactionStory)
    expect(reaction.story.data).to eq({ 'media_reaction_id' => reaction.id })
  end
end
