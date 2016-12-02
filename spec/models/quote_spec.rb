require 'rails_helper'

RSpec.describe Quote, type: :model do
  subject { build(:quote) }

  it { should belong_to(:user).counter_cache(true) }
  it { should belong_to(:media) }
  it { should belong_to(:character) }
  it { should have_many(:likes).class_name('QuoteLike') }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:media) }
  it { should validate_presence_of(:character) }
  it { should validate_presence_of(:content) }
end
