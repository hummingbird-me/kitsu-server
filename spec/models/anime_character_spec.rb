require 'rails_helper'

RSpec.describe AnimeCharacter, type: :model do
  it { should belong_to(:anime).required }
  it { should belong_to(:character).required }
  it { should define_enum_for(:role) }
end
