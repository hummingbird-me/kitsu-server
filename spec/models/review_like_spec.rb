require 'rails_helper'

RSpec.describe ReviewLike, type: :model do
  subject { build(:review_like) }
  it { should belong_to(:review).required }
  it { should belong_to(:user).required }
end
