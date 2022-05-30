require 'rails_helper'

RSpec.describe MediaReactionVote, type: :model do
  subject { build(:media_reaction_vote) }

  it { is_expected.to belong_to(:media_reaction).required }
  it { is_expected.to belong_to(:user).required }
end
