require 'rails_helper'

RSpec.describe GroupActionLog, type: :model do
  it { should belong_to(:target).required }
  it { should belong_to(:group).required }
  it { should belong_to(:user).required }
  it { should validate_presence_of(:verb) }
end
