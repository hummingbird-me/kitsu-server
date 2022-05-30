require 'rails_helper'

RSpec.describe ReviewLike, type: :model do
  subject { build(:review_like) }

  it { is_expected.to belong_to(:review).required }
  it { is_expected.to belong_to(:user).required }
end
