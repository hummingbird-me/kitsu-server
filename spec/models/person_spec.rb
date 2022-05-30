require 'rails_helper'

RSpec.describe Person, type: :model do
  it { is_expected.to have_many(:castings) }
  it { is_expected.to have_many(:anime_castings).dependent(:destroy) }
  it { is_expected.to have_many(:drama_castings).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:name) }
end
