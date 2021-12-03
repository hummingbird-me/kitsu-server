require 'rails_helper'

RSpec.describe ProfileLink, type: :model do
  it { should belong_to(:user).required }
  it { should belong_to(:profile_link_site).required }

  it { should validate_presence_of(:url) }
end
