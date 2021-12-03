require 'rails_helper'

RSpec.describe MediaReactionVote, type: :model do
  subject { build(:media_reaction_vote) }

  it { should belong_to(:media_reaction).required }
  it { should belong_to(:user).required }
end
