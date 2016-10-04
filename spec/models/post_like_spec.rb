require 'rails_helper'

RSpec.describe PostLike, type: :model do
  subject { build(:post_like) }

  it { should belong_to(:post) }
  it { should belong_to(:user) }
end
