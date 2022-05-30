require 'rails_helper'

RSpec.describe Casting, type: :model do
  it { is_expected.to belong_to(:media) }
  # TODO: test validation of either character or person
end
