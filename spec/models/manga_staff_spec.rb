require 'rails_helper'

RSpec.describe MangaStaff, type: :model do
  it { should belong_to(:manga).required }
  it { should belong_to(:person).required }
  it { should validate_length_of(:role).is_at_most(140) }
end
