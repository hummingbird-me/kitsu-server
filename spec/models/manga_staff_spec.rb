require 'rails_helper'

RSpec.describe MangaStaff, type: :model do
  it { is_expected.to belong_to(:manga).required }
  it { is_expected.to belong_to(:person).required }
  it { is_expected.to validate_length_of(:role).is_at_most(140) }
end
