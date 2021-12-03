require 'rails_helper'

RSpec.describe MediaReaction, type: :model do
  subject { build(:media_reaction) }

  it { should belong_to(:user).required }
  it { should belong_to(:library_entry).required }

  it { should validate_length_of(:reaction).is_at_most(140) }
  it { should_not allow_value('').for(:reaction) }
end
