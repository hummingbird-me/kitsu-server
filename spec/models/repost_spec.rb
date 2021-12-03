require 'rails_helper'

RSpec.describe Repost, type: :model do
  it { should belong_to(:user).required }
  it { should belong_to(:post).required }
end
