require 'rails_helper'

RSpec.describe Upload, type: :model do
  subject { build(:upload) }

  it { is_expected.to belong_to(:user).required }
end
