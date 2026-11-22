require 'rails_helper'

RSpec.describe Drama, type: :model do
  subject { build(:drama) }

  it { is_expected.to have_many(:drama_characters).dependent(:destroy) }
  it { is_expected.to have_many(:drama_staff).dependent(:destroy) }

  include_examples 'media'
  include_examples 'episodic'
  include_examples 'age_ratings'
end
