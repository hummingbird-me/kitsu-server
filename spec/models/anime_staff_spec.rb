require 'rails_helper'

RSpec.describe AnimeStaff, type: :model do
  it { should belong_to(:anime).required }
  it { should belong_to(:person).required }
  it { should validate_length_of(:role).is_at_most(140) }
end
