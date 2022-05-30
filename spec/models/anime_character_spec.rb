require 'rails_helper'

RSpec.describe AnimeCharacter, type: :model do
  it { is_expected.to belong_to(:anime).required }
  it { is_expected.to belong_to(:character).required }
  it { is_expected.to define_enum_for(:role) }
end
