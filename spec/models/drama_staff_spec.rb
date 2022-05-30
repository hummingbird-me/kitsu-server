require 'rails_helper'

RSpec.describe DramaStaff, type: :model do
  it { is_expected.to belong_to(:drama).required }
  it { is_expected.to belong_to(:person).required }
  it { is_expected.to validate_length_of(:role).is_at_most(140) }
end
