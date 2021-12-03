require 'rails_helper'

RSpec.describe Upload, type: :model do
  subject { build(:upload) }
  it { should belong_to(:user).required }
end
