require 'rails_helper'

RSpec.describe MediaAttribute, type: :model do
  subject { build(:media_attribute) }

  it { is_expected.to have_many(:anime) }
  it { is_expected.to have_many(:manga) }
  it { is_expected.to have_many(:drama) }
end
