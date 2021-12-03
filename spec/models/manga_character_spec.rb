require 'rails_helper'

RSpec.describe MangaCharacter, type: :model do
  it { should belong_to(:manga).required }
  it { should belong_to(:character).required }
  it { should define_enum_for(:role) }
end
