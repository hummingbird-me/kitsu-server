require 'rails_helper'

RSpec.describe Favorite, type: :model do
  subject { build(:favorite) }

  it { should belong_to(:user).required }
  it { should belong_to(:item).required }
end
