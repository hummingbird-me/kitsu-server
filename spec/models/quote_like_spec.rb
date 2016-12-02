require 'rails_helper'

RSpec.describe QuoteLike, type: :model do
  subject { build(:quote_like) }
  it { should belong_to(:quote) }
  it { should validate_presence_of(:quote) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
end
