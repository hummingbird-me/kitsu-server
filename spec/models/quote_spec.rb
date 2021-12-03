require 'rails_helper'

RSpec.describe Quote, type: :model do
  subject { build(:quote) }

  it { should belong_to(:user).counter_cache(true).required }
  it { should belong_to(:media).required }
  it { should have_many(:likes).class_name('QuoteLike') }

end
