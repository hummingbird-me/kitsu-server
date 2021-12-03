require 'rails_helper'

RSpec.describe MediaAttribute, type: :model do
  subject { build(:media_attribute) }

  it { should have_many(:anime) }
  it { should have_many(:manga) }
  it { should have_many(:drama) }
end
