require 'rails_helper'

RSpec.describe AnimeCasting, type: :model do
  it { should belong_to(:anime_character).required }
  it { should belong_to(:licensor).class_name('Producer').optional }
  it { should validate_length_of(:locale).is_at_most(20) }
  it { should validate_length_of(:notes).is_at_most(140) }
end
