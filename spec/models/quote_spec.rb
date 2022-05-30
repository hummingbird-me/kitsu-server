require 'rails_helper'

RSpec.describe Quote, type: :model do
  subject { build(:quote) }

  it { is_expected.to belong_to(:user).counter_cache(true).required }
  it { is_expected.to belong_to(:media).required }
  it { is_expected.to have_many(:likes).class_name('QuoteLike') }
end
