require 'rails_helper'

RSpec.describe Person, type: :model do
  it { should have_many(:castings) }
  it { should have_many(:anime_castings).dependent(:destroy) }
  it { should have_many(:drama_castings).dependent(:destroy) }
  it { should validate_presence_of(:name) }
end
