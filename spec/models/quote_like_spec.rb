require 'rails_helper'

RSpec.describe QuoteLike, type: :model do
  subject { build(:quote_like) }

  it { is_expected.to belong_to(:quote).required }
  it { is_expected.to belong_to(:user).required }
end
