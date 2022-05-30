require 'rails_helper'

RSpec.describe ProfileLink, type: :model do
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:profile_link_site).required }

  it { is_expected.to validate_presence_of(:url) }
end
