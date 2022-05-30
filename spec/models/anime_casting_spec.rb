require 'rails_helper'

RSpec.describe AnimeCasting, type: :model do
  it { is_expected.to belong_to(:anime_character).required }
  it { is_expected.to belong_to(:licensor).class_name('Producer').optional }
  it { is_expected.to validate_length_of(:locale).is_at_most(20) }
  it { is_expected.to validate_length_of(:notes).is_at_most(140) }
end
