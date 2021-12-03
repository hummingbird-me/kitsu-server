require 'rails_helper'

RSpec.describe Block, type: :model do
  it { should belong_to(:user).required }
  it { should belong_to(:blocked).class_name('User').required }
end
