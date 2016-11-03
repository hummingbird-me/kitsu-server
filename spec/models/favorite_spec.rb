require 'rails_helper'

RSpec.describe Favorite, type: :model do
  subject { build(:favorite) }

  it { should belong_to(:user) }
  it { should belong_to(:item) }
end
