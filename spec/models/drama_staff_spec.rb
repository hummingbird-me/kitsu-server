require 'rails_helper'

RSpec.describe DramaStaff, type: :model do
  it { should belong_to(:drama).required }
  it { should belong_to(:person).required }
  it { should validate_length_of(:role).is_at_most(140) }
end
