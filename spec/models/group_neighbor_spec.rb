require 'rails_helper'

RSpec.describe GroupNeighbor, type: :model do
  it do
    should belong_to(:source).class_name('Group').counter_cache('neighbors_count').required
  end
  it { should belong_to(:destination).class_name('Group').required }
end
