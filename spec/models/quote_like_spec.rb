require 'rails_helper'

RSpec.describe QuoteLike, type: :model do
  subject { build(:quote_like) }
  it { should belong_to(:quote).required }
  it { should belong_to(:user).required }
end
