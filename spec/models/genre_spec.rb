require 'rails_helper'

RSpec.describe Genre, type: :model do
  it { is_expected.to have_and_belong_to_many(:anime) }
  it { is_expected.to have_and_belong_to_many(:manga) }
end
