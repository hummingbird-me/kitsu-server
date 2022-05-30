require 'rails_helper'

RSpec.describe SiteAnnouncement, type: :model do
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to validate_presence_of(:title) }
end
