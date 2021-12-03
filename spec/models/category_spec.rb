require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { build(:category) }

  it { is_expected.to have_many(:anime).through(:media_categories) }
  it { is_expected.to have_many(:manga).through(:media_categories) }
end
