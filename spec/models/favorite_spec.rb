require 'rails_helper'

RSpec.describe Favorite, type: :model do
  subject { build(:favorite) }

  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:item).required }
end
