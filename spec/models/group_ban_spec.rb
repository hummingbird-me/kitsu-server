require 'rails_helper'

RSpec.describe GroupBan, type: :model do
  it { should belong_to(:group).required }
  it { should belong_to(:user).required }
  it { should belong_to(:moderator).class_name('User').required }
end
