require 'rails_helper'

RSpec.describe MangaCharacter, type: :model do
  it { is_expected.to belong_to(:manga).required }
  it { is_expected.to belong_to(:character).required }
  it { is_expected.to define_enum_for(:role) }
end
