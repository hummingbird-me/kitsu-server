require 'rails_helper'

RSpec.describe DramaCharacter, type: :model do
  it { is_expected.to belong_to(:drama).required }
  it { is_expected.to belong_to(:character).required }
  it { is_expected.to define_enum_for(:role) }
end
