require 'rails_helper'

RSpec.describe DramaCharacter, type: :model do
  it { should belong_to(:drama).required }
  it { should belong_to(:character).required }
  it { should define_enum_for(:role) }
end
