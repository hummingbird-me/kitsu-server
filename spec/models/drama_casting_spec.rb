require 'rails_helper'

RSpec.describe DramaCasting, type: :model do
  it { is_expected.to belong_to(:drama_character).required }
  it { is_expected.to belong_to(:person).required }
  it { is_expected.to belong_to(:licensor).class_name('Producer').optional }
  it { is_expected.to validate_length_of(:locale).is_at_most(20) }
  it { is_expected.to validate_length_of(:notes).is_at_most(140) }
end
