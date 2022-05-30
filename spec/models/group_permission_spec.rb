require 'rails_helper'

RSpec.describe GroupPermission, type: :model do
  it { is_expected.to belong_to(:group_member).required }
  it { is_expected.to define_enum_for(:permission) }
end
