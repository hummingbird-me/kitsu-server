require 'rails_helper'

RSpec.describe GroupPermission, type: :model do
  it { should belong_to(:group_member).required }
  it { should define_enum_for(:permission) }
end
